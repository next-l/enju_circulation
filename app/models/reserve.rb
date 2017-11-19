class Reserve < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  scope :hold, -> { where(id: Reserve.joins(:retain).select(:id)) }
  scope :waiting, -> { not_in_state(:canceled, :completed, :expired, :retained) }
  scope :canceled, -> { in_state(:canceled) }
  scope :will_expire_on, ->(date) { where(id: Reserve.joins(:reserve_and_expiring_date).where('reserve_and_expiring_dates.expire_on <= ?', date)) }
  scope :created, ->(start_date, end_date) { where('created_at >= ? AND created_at < ?', start_date, end_date) }
  scope :not_sent_expiration_notice_to_patron, -> { in_state(:expired).where(expiration_notice_to_patron: false) }
  scope :not_sent_expiration_notice_to_library, -> { in_state(:expired).where(expiration_notice_to_library: false) }
  scope :sent_expiration_notice_to_patron, -> { in_state(:expired).where(expiration_notice_to_patron: true) }
  scope :sent_expiration_notice_to_library, -> { in_state(:expired).where(expiration_notice_to_library: true) }
  scope :not_sent_cancel_notice_to_patron, -> { in_state(:canceled).where(expiration_notice_to_patron: false) }
  scope :not_sent_cancel_notice_to_library, -> { in_state(:canceled).where(expiration_notice_to_library: false) }
  belongs_to :user
  belongs_to :manifestation, touch: true
  belongs_to :librarian, class_name: 'User'
  belongs_to :item, touch: true
  belongs_to :request_status_type
  belongs_to :pickup_location, class_name: 'Library'
  has_one :reserve_and_expiring_date
  has_one :retain

  validates_associated :user, :librarian, :request_status_type
  validates :manifestation, associated: true # , on: :create
  validates :pickup_location, presence: true
  validates :user, presence: true
  validates :request_status_type, presence: true
  validates :manifestation, presence: true, unless: proc { |reserve|
    reserve.completed?
  }
  # validates_uniqueness_of :manifestation_id, scope: :user_id
  #validates_date :expired_at, allow_blank: true
  #validate :manifestation_must_include_item
  validate :check_expiring_date
  validate :available_for_reservation?, on: :create
  validate :valid_item?
  before_validation :set_manifestation, on: :create
  #before_validation :set_item
  before_validation :set_user, on: :update
  before_validation :set_request_status, on: :create
  before_save :set_expiring_date
  after_save :create_retain
  after_save do
    if item
      item.checkouts.map(&:index)
      Sunspot.commit
    end
  end

  attr_accessor :user_number, :item_identifier, :force_retaining, :expire_on

  paginates_per 10

  def state_machine
    ReserveStateMachine.new(self, transition_class: ReserveTransition)
  end

  has_many :reserve_transitions

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
           to: :state_machine

  searchable do
    text :username do
      user.try(:username)
    end
    string :username do
      user.try(:username)
    end
    string :user_number do
      user.profile.try(:user_number)
    end
    time :created_at
    text :item_identifier do
      retain.item.item_identifier if retain
    end
    text :title do
      manifestation.try(:titles)
    end
    boolean :hold do |reserve|
      hold.include?(reserve)
    end
    string :state do
      state_machine.current_state
    end
    string :title_transcription do
      manifestation.try(:title_transcription)
    end
    integer :manifestation_id
  end

  def set_manifestation
    self.manifestation = item.manifestation if item
  end

  def create_retain
    if item_identifier.present?
      item = Item.find_by(item_identifier: item_identifier)
      Retain.where(reserve: self, item: item).first_or_create! if item
    end
  end

  def set_user
    number = user_number.to_s.strip
    if number.present?
      self.user = Profile.find_by(user_number: number).try(:user)
    end
  end

  def valid_item?
    if item_identifier.present?
      item = Item.find_by(item_identifier: item_identifier)
      errors[:base] << I18n.t('reserve.invalid_item') unless item
    end
  end

  def set_request_status
    self.request_status_type = RequestStatusType.find_by(name: 'In Process')
  end

  def next_reservation
    if item
      Reserve.waiting.where(manifestation_id: item.manifestation.id).readonly(false).first
    end
  end

  def send_message(sender = nil)
    sender = User.find(1) unless sender # TODO: システムからのメッセージの発信者
    Reserve.transaction do
      case state_machine.current_state
      when 'requested'
        message_template_to_patron = MessageTemplate.localized_template('reservation_accepted_for_patron', user.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: user, message_template: message_template_to_patron)
        request.save_message_body(manifestations: Array[manifestation], user: user)
        request.transition_to!(:sent) # 受付時は即時送信
        message_template_to_library = MessageTemplate.localized_template('reservation_accepted_for_library', user.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: sender, message_template: message_template_to_library)
        request.save_message_body(manifestations: Array[manifestation], user: user)
        request.transition_to!(:sent) # 受付時は即時送信
      when 'canceled'
        message_template_to_patron = MessageTemplate.localized_template('reservation_canceled_for_patron', user.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: user, message_template: message_template_to_patron)
        request.save_message_body(manifestations: Array[manifestation], user: user)
        request.transition_to!(:sent) # キャンセル時は即時送信
        message_template_to_library = MessageTemplate.localized_template('reservation_canceled_for_library', user.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: sender, message_template: message_template_to_library)
        request.save_message_body(manifestations: Array[manifestation], user: user)
        request.transition_to!(:sent) # キャンセル時は即時送信
      when 'expired'
        message_template_to_patron = MessageTemplate.localized_template('reservation_expired_for_patron', user.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: user, message_template: message_template_to_patron)
        request.save_message_body(manifestations: Array[manifestation], user: user)
        request.transition_to!(:sent)
        reload
        update_attribute(:expiration_notice_to_patron, true)
        message_template_to_library = MessageTemplate.localized_template('reservation_expired_for_library', sender.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: sender, message_template: message_template_to_library)
        request.save_message_body(manifestations: Array[manifestation], user: sender)
        request.transition_to!(:sent)
      when 'postponed'
        message_template_for_patron = MessageTemplate.localized_template('reservation_postponed_for_patron', user.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: user, message_template: message_template_for_patron)
        request.save_message_body(manifestations: Array[manifestation], user: user)
        request.transition_to!(:sent)
        message_template_for_library = MessageTemplate.localized_template('reservation_postponed_for_library', user.profile.locale)
        request = MessageRequest.new
        request.assign_attributes(sender: sender, receiver: sender, message_template: message_template_for_library)
        request.save_message_body(manifestations: Array[manifestation], user: user)
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
      message_template_to_library = MessageTemplate.localized_template('reservation_expired_for_library', sender.profile.locale)
      request = MessageRequest.new
      request.assign_attributes(sender: sender, receiver: sender, message_template: message_template_to_library)
      request.save_message_body(manifestations: options[:manifestations])
      not_sent_expiration_notice_to_library.readonly(false).each do |reserve|
        reserve.expiration_notice_to_library = true
        reserve.save(validate: false)
      end
    # when 'canceled'
    #  message_template_to_library = MessageTemplate.localized_template('reservation_canceled_for_library', sender.locale)
    #  request = MessageRequest.new
    #  request.assign_attributes({sender: sender, receiver: sender, message_template: message_template_to_library})
    #  request.save_message_body(manifestations: self.not_sent_expiration_notice_to_library.collect(&:manifestation))
    #  self.not_sent_cancel_notice_to_library.each do |reserve|
    #    reserve.update_attribute(:expiration_notice_to_library, true)
    #  end
    else
      raise 'status not defined'
    end
  end

  def self.expire
    Reserve.transaction do
      will_expire_on(Time.zone.now.beginning_of_day).in_state(:retained).readonly(false).map { |r| r.transition_to!(:expired) }
      will_expire_on(Time.zone.now.beginning_of_day).in_state(:pending).readonly(false).map { |r| r.transition_to!(:expired) }

      # キューに登録した時点では本文は作られないので
      # 予約の連絡をすませたかどうかを識別できるようにしなければならない
      # reserve.send_message('expired')
      User.find_each do |user|
        unless user.reserves.not_sent_expiration_notice_to_patron.empty?
          user.send_message('reservation_expired_for_patron', manifestations: user.reserves.not_sent_expiration_notice_to_patron.collect(&:manifestation))
        end
      end
      unless Reserve.not_sent_expiration_notice_to_library.empty?
        Reserve.send_message_to_library('expired', manifestations: Reserve.not_sent_expiration_notice_to_library.collect(&:manifestation))
      end
    end
    # rescue
    #  logger.info "#{Time.zone.now} expiring reservations failed!"
  end

  def checked_out_now?
    if user && manifestation
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
    %w(canceled expired completed).include?(state_machine.current_state)
  end

  def set_expiring_date
    return unless expire_on.present?
    self.reserve_and_expiring_date = ReserveAndExpiringDate.new(reserve: self, expire_on: expire_on)
  end

  def check_expiring_date
    if expire_on.present?
      if Date.parse(expire_on) < Date.today
        errors.add(:expire_on)
      end
    end
  end

  private

  def manifestation_must_include_item
    if item_id.present? && !completed?
      errors[:base] << I18n.t('reserve.invalid_item') unless manifestation.items.include?(item)
    end
  end

  has_one :inter_library_loan if defined?(EnjuInterLibraryLoan)

  def self.transition_class
    ReserveTransition
  end

  def self.initial_state
    :pending
  end
end

# == Schema Information
#
# Table name: reserves
#
#  id                           :uuid             not null, primary key
#  user_id                      :integer          not null
#  manifestation_id             :uuid             not null
#  item_id                      :uuid
#  request_status_type_id       :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  expiration_notice_to_patron  :boolean          default(FALSE), not null
#  expiration_notice_to_library :boolean          default(FALSE), not null
#  pickup_location_id           :uuid             not null
#  lock_version                 :integer          default(0), not null
#
