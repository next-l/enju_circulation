# -*- encoding: utf-8 -*-
class Reserve < ActiveRecord::Base
  attr_accessible :manifestation_id, :item_identifier, :user_number, :expired_at
  attr_accessible :manifestation_id, :item_identifier, :user_number,
    :expired_at, :request_status_type, :canceled_at, :checked_out_at,
    :expiration_notice_to_patron, :expiration_notice_to_library,
    :as => :admin
  scope :hold, where('item_id IS NOT NULL')
  scope :not_hold, where(:item_id => nil)
  scope :waiting, where('canceled_at IS NULL AND expired_at > ? AND state != ?', Time.zone.now, 'completed').order('reserves.id DESC')
  scope :completed, where('checked_out_at IS NOT NULL')
  scope :canceled, where('canceled_at IS NOT NULL')
  scope :will_expire_retained, lambda {|datetime| {:conditions => ['checked_out_at IS NULL AND canceled_at IS NULL AND expired_at <= ? AND state = ?', datetime, 'retained'], :order => 'expired_at'}}
  scope :will_expire_pending, lambda {|datetime| {:conditions => ['checked_out_at IS NULL AND canceled_at IS NULL AND expired_at <= ? AND state = ?', datetime, 'pending'], :order => 'expired_at'}}
  scope :created, lambda {|start_date, end_date| {:conditions => ['created_at >= ? AND created_at < ?', start_date, end_date]}}
  scope :not_sent_expiration_notice_to_patron, where(:state => 'expired', :expiration_notice_to_patron => false)
  scope :not_sent_expiration_notice_to_library, where(:state => 'expired', :expiration_notice_to_library => false)
  scope :sent_expiration_notice_to_patron, where(:state => 'expired', :expiration_notice_to_patron => true)
  scope :sent_expiration_notice_to_library, where(:state => 'expired', :expiration_notice_to_library => true)
  scope :not_sent_cancel_notice_to_patron, where(:state => 'canceled', :expiration_notice_to_patron => false)
  scope :not_sent_cancel_notice_to_library, where(:state => 'canceled', :expiration_notice_to_library => false)

  belongs_to :user, :validate => true
  belongs_to :manifestation, :validate => true
  belongs_to :librarian, :class_name => 'User', :validate => true
  belongs_to :item, :validate => true
  belongs_to :request_status_type

  validates_associated :user, :librarian, :item, :request_status_type, :manifestation
  validates_presence_of :user, :manifestation, :request_status_type #, :expired_at
  #validates_uniqueness_of :manifestation_id, :scope => :user_id
  validates_date :expired_at, :allow_blank => true
  validate :manifestation_must_include_item
  validate :available_for_reservation?, :on => :create
  before_validation :set_item_and_manifestation, :on => :create
  before_validation :set_expired_at
  before_validation :set_request_status, :on => :create

  attr_accessor :user_number, :item_identifier

  state_machine :initial => :pending do
    before_transition :pending => :requested, :do => :do_request
    before_transition [:pending, :requested, :retained] => :retained, :do => :retain
    before_transition [:pending ,:requested, :retained] => :canceled, :do => :cancel
    before_transition [:pending, :requested, :retained] => :expired, :do => :expire
    before_transition :retained => :completed, :do => :checkout
    after_transition any => any do |reserve, transition|
      if Rails.env == 'production'
        ExpireFragmentCache.expire_fragment_cache(reserve.manifestation)
      end
    end

    event :sm_request do
      transition :pending => :requested
    end

    event :sm_retain do
      transition [:pending, :requested, :retained] => :retained
    end

    event :sm_cancel do
      transition [:pending, :requested, :retained] => :canceled
    end

    event :sm_expire do
      transition [:pending, :requested, :retained] => :expired
    end

    event :sm_complete do
      transition [:pending, :requested, :retained] => :completed
    end
  end

  paginates_per 10

  def set_item_and_manifestation
    item = Item.where(:item_identifier => item_identifier).first
    manifestation = item.manifestation if item
  end

  def set_request_status
    self.request_status_type = RequestStatusType.where(:name => 'In Process').first
  end

  def set_expired_at
    if self.user and self.manifestation
      if self.canceled_at.blank?
        if self.expired_at.blank?
          expired_period = self.manifestation.reservation_expired_period(self.user)
          self.expired_at = (expired_period + 1).days.from_now.beginning_of_day
        elsif self.expired_at.beginning_of_day < Time.zone.now
          errors[:base] << I18n.t('reserve.invalid_date')
        end
      end
    end
  end

  def manifestation_must_include_item
    unless item_id.blank?
      item = Item.find(item_id) rescue nil
      errors[:base] << I18n.t('reserve.invalid_item') unless manifestation.items.include?(item)
    end
  end

  def next_reservation
    if item
      Reserve.waiting.where(:manifestation_id => item.manifestation.id).first
    end
  end

  def send_message(sender = nil)
    sender = User.find(1) unless sender # TODO: システムからのメッセージの発信者
    Reserve.transaction do
      case state
      when 'requested'
        message_template_to_patron = MessageTemplate.localized_template('reservation_accepted_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_to_patron}, :as => :admin)
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.sm_send_message! # 受付時は即時送信
        message_template_to_library = MessageTemplate.localized_template('reservation_accepted_for_library', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library}, :as => :admin)
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.sm_send_message! # 受付時は即時送信
      when 'canceled'
        message_template_to_patron = MessageTemplate.localized_template('reservation_canceled_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_to_patron}, :as => :admin)
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.sm_send_message! # キャンセル時は即時送信
        message_template_to_library = MessageTemplate.localized_template('reservation_canceled_for_library', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library}, :as => :admin)
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.sm_send_message! # キャンセル時は即時送信
      when 'expired'
        message_template_to_patron = MessageTemplate.localized_template('reservation_expired_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_to_patron}, :as => :admin)
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.sm_send_message!
        self.update_attribute(:expiration_notice_to_patron, true)
        message_template_to_library = MessageTemplate.localized_template('reservation_expired_for_library', sender.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library}, :as => :admin)
        request.save_message_body(:manifestations => Array[manifestation], :user => sender)
        request.sm_send_message!
      when 'retained'
        message_template_for_patron = MessageTemplate.localized_template('item_received_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_for_patron}, :as => :admin)
        request.save_message_body(:manifestations => Array[item.manifestation], :user => user)
        request.sm_send_message!
        message_template_for_library = MessageTemplate.localized_template('item_received_for_library', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_for_library}, :as => :admin)
        request.save_message_body(:manifestations => Array[item.manifestation], :user => user)
        request.sm_send_message!
      else
        raise 'status not defined'
      end
    end
  end

  def self.send_message_to_library(status, options = {})
    sender = User.find(1) # TODO: システムからのメッセージの発信者
    case status
    when 'expired'
      message_template_to_library = MessageTemplate.localized_template('reservation_expired_for_library', sender.locale)
      request = MessageRequest.new
      request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library}, :as => :admin)
      request.save_message_body(:manifestations => options[:manifestations])
      self.not_sent_expiration_notice_to_library.each do |reserve|
        reserve.expiration_notice_to_library = true
        reserve.save(:validate => false)
      end
    #when 'canceled'
    #  message_template_to_library = MessageTemplate.localized_template('reservation_canceled_for_library', sender.locale)
    #  request = MessageRequest.new
    #  request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library}, :as => :admin)
    #  request.save_message_body(:manifestations => self.not_sent_expiration_notice_to_library.collect(&:manifestation))
    #  self.not_sent_cancel_notice_to_library.each do |reserve|
    #    reserve.update_attribute(:expiration_notice_to_library, true)
    #  end
    else
      raise 'status not defined'
    end
  end

  def self.expire
    Reserve.transaction do
      self.will_expire_retained(Time.zone.now.beginning_of_day).map{|r| r.sm_expire!}
      self.will_expire_pending(Time.zone.now.beginning_of_day).map{|r| r.sm_expire!}

      # キューに登録した時点では本文は作られないので
      # 予約の連絡をすませたかどうかを識別できるようにしなければならない
      # reserve.send_message('expired')
      User.find_each do |user|
        unless user.reserves.not_sent_expiration_notice_to_patron.empty?
          user.send_message('reservation_expired_for_patron', :manifestations => user.reserves.not_sent_expiration_notice_to_patron.collect(&:manifestation))
        end
      end
      unless Reserve.not_sent_expiration_notice_to_library.empty?
        Reserve.send_message_to_library('expired', :manifestations => Reserve.not_sent_expiration_notice_to_library.collect(&:manifestation))
      end
    end
  #rescue
  #  logger.info "#{Time.zone.now} expiring reservations failed!"
  end

  def checked_out_now?
    if user and manifestation
      true if !(user.checkouts.not_returned.pluck(:item_id) & manifestation.items.pluck(:item_id)).empty?
    end
  end

  def available_for_reservation?
    if manifestation
      if checked_out_now?
        errors[:base] << I18n.t('reserve.this_manifestation_is_already_checked_out')
      end

      if manifestation.is_reserved_by?(user)
        errors[:base] << I18n.t('reserve.this_manifestation_is_already_reserved')
      end
      if user.try(:reached_reservation_limit?, manifestation)
        errors[:base] << I18n.t('reserve.excessed_reservation_limit')
      end

      expired_period = manifestation.try(:reservation_expired_period, user)
      if expired_period.nil?
        errors[:base] << I18n.t('reserve.this_patron_cannot_reserve')
      end
    end
  end

  private
  def do_request
    self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'In Process').first}, :as => :admin)
    save!
  end

  def retain
    # TODO: 「取り置き中」の状態を正しく表す
    self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'In Process').first, :checked_out_at => Time.zone.now}, :as => :admin)
    save!
  end

  def expire
    self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'Expired').first, :canceled_at => Time.zone.now}, :as => :admin)
    save!
    logger.info "#{Time.zone.now} reserve_id #{self.id} expired!"
    reserve = next_reservation
    if reserve
      reserve.item = item
      reserve.sm_retain!
      reserve.send_message
    end
  end

  def cancel
    self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'Cannot Fulfill Request').first, :canceled_at => Time.zone.now}, :as => :admin)
    save!
    reserve = next_reservation
    if reserve
      reserve.item = item
      reserve.sm_retain!
      reserve.send_message
    end
  end

  def checkout
    self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'Available For Pickup').first, :checked_out_at => Time.zone.now}, :as => :admin)
    save!
  end

  if defined?(EnjuInterLibraryLoan)
    has_one :inter_library_loan
  end
end

# == Schema Information
#
# Table name: reserves
#
#  id                           :integer          not null, primary key
#  user_id                      :integer          not null
#  manifestation_id             :integer          not null
#  item_id                      :integer
#  request_status_type_id       :integer          not null
#  checked_out_at               :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  canceled_at                  :datetime
#  expired_at                   :datetime
#  deleted_at                   :datetime
#  state                        :string(255)
#  expiration_notice_to_patron  :boolean          default(FALSE)
#  expiration_notice_to_library :boolean          default(FALSE)
#

