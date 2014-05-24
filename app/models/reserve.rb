# -*- encoding: utf-8 -*-
class Reserve < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordModel
  scope :hold, -> {where('item_id IS NOT NULL')}
  scope :not_hold, -> {where(:item_id => nil)}
  scope :waiting, -> {not_in_state(:completed).where('canceled_at IS NULL AND expired_at > ?', Time.zone.now).order('reserves.id DESC')}
  scope :retained, -> {in_state(:retained).where('retained_at IS NOT NULL')}
  scope :completed, -> {in_state(:completed).where('checked_out_at IS NOT NULL')}
  #scope :canceled, -> {where('canceled_at IS NOT NULL AND state = ?', 'canceled')}
  #scope :postponed, -> {where('postponed_at IS NOT NULL AND state = ?', 'postponed')}
  scope :will_expire_retained, lambda {|datetime| in_state(:retained).where('checked_out_at IS NULL AND canceled_at IS NULL AND expired_at <= ?', datetime).order('expired_at')}
  scope :will_expire_pending, lambda {|datetime| in_state(:pending).where('checked_out_at IS NULL AND canceled_at IS NULL AND expired_at <= ?', datetime).order('expired_at')}
  scope :created, lambda {|start_date, end_date| where('created_at >= ? AND created_at < ?', start_date, end_date)}
  scope :not_sent_expiration_notice_to_patron, -> {in_state(:expired).where(:expiration_notice_to_patron => false)}
  scope :not_sent_expiration_notice_to_library, -> {in_state(:expired).where(:expiration_notice_to_library => false)}
  #scope :sent_expiration_notice_to_patron, -> {where(:state => 'expired', :expiration_notice_to_patron => true)}
  #scope :sent_expiration_notice_to_library, -> {where(:state => 'expired', :expiration_notice_to_library => true)}
  #scope :not_sent_cancel_notice_to_agent, -> {where(:state => 'canceled', :expiration_notice_to_patron => false)}
  #scope :not_sent_cancel_notice_to_library, -> {where(:state => 'canceled', :expiration_notice_to_library => false)}

  belongs_to :user #, :validate => true
  belongs_to :manifestation #, :validate => true
  belongs_to :librarian, :class_name => 'User' #, :validate => true
  belongs_to :item #, :validate => true
  belongs_to :request_status_type

  validates_associated :user, :librarian, :request_status_type
  validates :manifestation, :associated => true #, :on => :create
  validates_presence_of :user, :request_status_type
  validates :manifestation, :presence => true, :unless => Proc.new{|reserve|
    reserve.completed?
  }
  #validates_uniqueness_of :manifestation_id, :scope => :user_id
  validates_date :expired_at, :allow_blank => true
  validate :manifestation_must_include_item
  validate :available_for_reservation?, :on => :create
  validates :item_id, :presence => true, :if => Proc.new{|reserve|
    if item_id_changed?
      if reserve.completed? or reserve.retained?
        if item_id_change[0]
          if item_id_change[1]
            true
          else
            false
          end
        else
          false
        end
      end
    else
      if reserve.retained?
        true
      end
    end
  }
  validate :retained_by_other_user?
  before_validation :set_manifestation, :on => :create
  before_validation :set_item, :set_expired_at
  before_validation :set_user, :on => :update
  before_validation :set_request_status, :on => :create

  attr_accessor :user_number, :item_identifier, :force_retaining

  include Statesman::Adapters::ActiveRecordModel

  has_many :reserve_transitions

  def state_machine
    @state_machine ||= ReserveStateMachine.new(self, transition_class: ReserveTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  #state_machine :initial => :pending do
    #before_transition [:pending, :postponed] => :requested, :do => :do_request
    #before_transition :retained => :postponed, :do => :postpone
    #before_transition [:pending, :requested, :retained, :postponed] => :retained, :do => :retain
    #before_transition [:pending ,:requested, :retained, :postponed] => :canceled, :do => :cancel
    #before_transition [:pending, :requested, :retained, :postponed] => :expired, :do => :expire
    #before_transition :retained => :completed, :do => :checkout
  #  after_transition any => any do |reserve, transition|
  #    if Rails.env == 'production'
  #      ExpireFragmentCache.expire_fragment_cache(reserve.manifestation)
  #    end
  #  end

  #  after_transition any => [:requested, :canceled, :retained, :postponed] do |reserve, transition|
  #    reserve.send_message
  #  end

  #  event :sm_request do
  #    transition [:pending, :requested] => :requested
  #  end

  #  event :sm_retain do
  #    transition [:pending, :requested, :retained, :postponed] => :retained
  #  end

  #  event :sm_cancel do
  #    transition [:pending, :requested, :retained, :postponed] => :canceled
  #  end

  #  event :sm_expire do
  #    transition [:pending, :requested, :retained, :postponed] => :expired
  #  end

  #  event :sm_postpone do
  #    transition :retained => :postponed
  #  end

  #  event :sm_complete do
  #    transition [:pending, :requested, :retained] => :completed
  #  end
  #end

  paginates_per 10

  searchable do
    text :username do
      user.try(:username)
    end
    string :username do
      user.try(:username)
    end
    string :user_number do
      user.try(:user_number)
    end
    time :created_at
    text :item_identifier do
      manifestation.items.pluck(:item_identifier)
    end
    text :title do
      manifestation.try(:titles)
    end
    boolean :hold do |reserve|
      self.hold.include?(reserve)
    end
    string :state do
      current_state
    end
    string :title_transcription do
      manifestation.try(:title_transcription)
    end
  end

  def set_manifestation
    self.manifestation = item.manifestation if item
  end

  def set_item
    identifier = item_identifier.to_s.strip
    if identifier.present?
      item = Item.where(:item_identifier => identifier).first
      self.item = item
    end
  end

  def set_user
    number = user_number.to_s.strip
    if number.present?
      user = User.where(:user_number => number).first
      self.user = user
    end
  end

  def retained_by_other_user?
    return nil if force_retaining == '1'
    if item and !retained?
      if Reserve.retained.where(:item_id => item.item_identifier).count > 0
        errors[:base] << I18n.t('reserve.attempt_to_update_retained_reservation')
      end
    end
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
        elsif !completed?
          if self.expired_at.beginning_of_day < Time.zone.now
            errors[:base] << I18n.t('reserve.invalid_date')
          end
        end
      end
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
      case current_state
      when 'requested'
        message_template_to_agent = MessageTemplate.localized_template('reservation_accepted_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_to_agent})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent) # 受付時は即時送信
        message_template_to_library = MessageTemplate.localized_template('reservation_accepted_for_library', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent) # 受付時は即時送信
      when 'canceled'
        message_template_to_agent = MessageTemplate.localized_template('reservation_canceled_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_to_agent})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent) # キャンセル時は即時送信
        message_template_to_library = MessageTemplate.localized_template('reservation_canceled_for_library', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent) # キャンセル時は即時送信
      when 'expired'
        message_template_to_agent = MessageTemplate.localized_template('reservation_expired_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_to_agent})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent)
        self.expiration_notice_to_patron = true
        message_template_to_library = MessageTemplate.localized_template('reservation_expired_for_library', sender.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library})
        request.save_message_body(:manifestations => Array[manifestation], :user => sender)
        request.transition_to!(:sent)
      when 'retained'
        message_template_for_patron = MessageTemplate.localized_template('item_received_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_for_patron})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent)
        message_template_for_library = MessageTemplate.localized_template('item_received_for_library', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_for_library})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent)
      when 'postponed'
        message_template_for_patron = MessageTemplate.localized_template('reservation_postponed_for_patron', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => user, :message_template => message_template_for_patron})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent)
        message_template_for_library = MessageTemplate.localized_template('reservation_postponed_for_library', user.locale)
        request = MessageRequest.new
        request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_for_library})
        request.save_message_body(:manifestations => Array[manifestation], :user => user)
        request.transition_to!(:sent)
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
      request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library})
      request.save_message_body(:manifestations => options[:manifestations])
      self.not_sent_expiration_notice_to_library.each do |reserve|
        reserve.expiration_notice_to_library = true
        reserve.save(:validate => false)
      end
    #when 'canceled'
    #  message_template_to_library = MessageTemplate.localized_template('reservation_canceled_for_library', sender.locale)
    #  request = MessageRequest.new
    #  request.assign_attributes({:sender => sender, :receiver => sender, :message_template => message_template_to_library})
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
      self.will_expire_retained(Time.zone.now.beginning_of_day).map{|r| r.transition_to!(:expired)}
      self.will_expire_pending(Time.zone.now.beginning_of_day).map{|r| r.transition_to!(:expired)}

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
      true unless (user.checkouts.not_returned.pluck(:item_id) & manifestation.items.pluck('items.id')).empty?
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

  def completed?
    %w(canceled expired completed).include?(current_state)
  end

  def retained?
    return true if current_state == 'retained'
    false
  end

  private
  def self.transition_class
    ReserveTransition
  end

  def do_request
    self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'In Process').first, :item_id => nil, :retained_at => nil})
    save!
  end

  def retain
    # TODO: 「取り置き中」の状態を正しく表す
    self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'In Process').first, :retained_at => Time.zone.now})
    Reserve.transaction do
      if item.try(:next_reservation)
        reservation = item.next_reservation
        reservation.transition_to!(:postponed)
      end
      save!
    end
  end

  def expire
    Reserve.transaction do
      self.assign_attributes({:request_status_type => RequestStatusType.where(:name => 'Expired').first, :canceled_at => Time.zone.now})
      reserve = next_reservation
      if reserve
        reserve.item = item
        self.item = nil
        save!
        reserve.transition_to!(:retained)
      end
    end
    logger.info "#{Time.zone.now} reserve_id #{self.id} expired!"
  end

  def cancel
  end

  def checkout
    assign_attributes({:request_status_type => RequestStatusType.where(:name => 'Available For Pickup').first, :checked_out_at => Time.zone.now})
  end

  def postpone
    assign_attributes({
      :request_status_type => RequestStatusType.where(:name => 'In Process').first,
      :item_id => nil,
      :retained_at => nil,
      :postponed_at => Time.zone.now
    })
  end

  def manifestation_must_include_item
    if item_id.present? and !completed?
      errors[:base] << I18n.t('reserve.invalid_item') unless manifestation.items.include?(item)
    end
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
#  retained_at                  :datetime
#  postponed_at                 :datetime
#  lock_version                 :integer          default(0), not null
#

