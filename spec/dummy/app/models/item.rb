# -*- encoding: utf-8 -*-
class Item < ActiveRecord::Base
  scope :on_shelf, where('shelf_id != 1')
  scope :on_web, where(:shelf_id => 1)

  scope :for_checkout, where('item_identifier IS NOT NULL')
  scope :not_for_checkout, where(:item_identifier => nil)
  has_one :exemplify
  has_one :manifestation, :through => :exemplify
  has_many :checkouts
  has_many :reserves
  has_many :reserved_patrons, :through => :reserves, :class_name => 'Patron'
  has_many :checked_items, :dependent => :destroy
  has_many :baskets, :through => :checked_items
  belongs_to :circulation_status, :validate => true
  belongs_to :checkout_type
  has_many :lending_policies, :dependent => :destroy
  has_one :item_has_use_restriction, :dependent => :destroy
  has_one :use_restriction, :through => :item_has_use_restriction
  belongs_to :shelf, :counter_cache => true, :validate => true

  validates_associated :circulation_status, :checkout_type
  validates_presence_of :circulation_status, :checkout_type
  before_save :set_use_restriction
  searchable do
    integer :circulation_status_id
  end
  attr_accessor :use_restriction_id
  attr_accessor :library_id, :manifestation_id

  def set_circulation_status
    self.circulation_status = CirculationStatus.where(:name => 'In Process').first if self.circulation_status.nil?
  end

  def set_use_restriction
    if self.use_restriction_id
      self.use_restriction = UseRestriction.where(:id => self.use_restriction_id).first
    else
      return if use_restriction
      self.use_restriction = UseRestriction.where(:name => 'Limited Circulation, Normal Loan Period').first
    end
  end

  def checkout_status(user)
     user.user_group.user_group_has_checkout_types.where(:checkout_type_id => self.checkout_type.id).first
  end

  def next_reservation
    Reserve.waiting.where(:manifestation_id => self.manifestation.id).first
  end

  def reserved?
    return true if self.next_reservation
    false
  end

  def reservable_by?(user)
    if manifestation.is_reservable_by?(user)
      return false if ['Lost', 'Missing', 'Claimed Returned Or Never Borrowed'].include?(self.circulation_status.name)
      return false if self.item_identifier.blank?
      true
    else
      false
    end
  end

  def rent?
    return true if self.checkouts.not_returned.select(:item_id).detect{|checkout| checkout.item_id == self.id}
    false
  end

  def reserved_by_user?(user)
    if self.next_reservation
      return true if self.next_reservation.user == user
    end
    false
  end

  def available_for_checkout?
    circulation_statuses = CirculationStatus.available_for_checkout.select(:id)
    return true if circulation_statuses.include?(self.circulation_status)
    false
  end

  def checkout!(user)
    self.circulation_status = CirculationStatus.where(:name => 'On Loan').first
    if self.reserved_by_user?(user)
      self.next_reservation.update_attributes(:checked_out_at => Time.zone.now)
      self.next_reservation.sm_complete!
    end
    save!
  end

  def checkin!
    self.circulation_status = CirculationStatus.where(:name => 'Available On Shelf').first
    save(:validate => false)
  end

  def retain(librarian)
    Item.transaction do
      reservation = self.manifestation.next_reservation
      unless reservation.nil?
        reservation.item = self
        reservation.sm_retain!
        reservation.update_attributes({:request_status_type => RequestStatusType.where(:name => 'In Process').first})
        request = MessageRequest.new(:sender_id => librarian.id, :receiver_id => reservation.user_id)
        message_template = MessageTemplate.localized_template('item_received', reservation.user.locale)
        request.message_template = message_template
        request.save!
      end
    end
  end

  def lending_rule(user)
    lending_policies.where(:user_group_id => user.user_group.id).first
  end

  def not_for_loan?
    if use_restriction.try(:name) == 'Not For Loan'
      true
    else
      false
    end
  end
end
