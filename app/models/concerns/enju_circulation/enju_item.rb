module EnjuCirculation
  module EnjuItem
    extend ActiveSupport::Concern

    included do
      FOR_CHECKOUT_CIRCULATION_STATUS = [
        'Available On Shelf',
        'Missing',
        'On Loan',
        'Waiting To Be Reshelved'
      ].freeze
      FOR_CHECKOUT_USE_RESTRICTION = [
        'Available For Supply Without Return',
        'Limited Circulation, Long Loan Period',
        'Limited Circulation, Short Loan Period',
        'No Reproduction',
        'Overnight Only',
        'Renewals Not Permitted',
        'Supervision Required',
        'Term Loan',
        'User Signature Required',
        'Limited Circulation, Normal Loan Period'
      ].freeze

      scope :for_checkout, ->(identifier_conditions = 'item_identifier IS NOT NULL') {
        includes(:circulation_status, :use_restriction).where(
          'circulation_statuses.name' => FOR_CHECKOUT_CIRCULATION_STATUS,
          'use_restrictions.name' => FOR_CHECKOUT_USE_RESTRICTION
        ).where(identifier_conditions)
      }
      scope :removed, -> { includes(:circulation_status).where('circulation_statuses.name' => 'Removed') }
      has_many :checkouts
      has_many :reserves
      has_many :retains
      has_many :checked_items
      has_many :baskets, through: :checked_items
      belongs_to :circulation_status
      belongs_to :checkout_type
      has_one :item_has_use_restriction, dependent: :destroy
      has_one :use_restriction, through: :item_has_use_restriction
      validates_associated :circulation_status, :checkout_type
      validates_presence_of :circulation_status, :checkout_type
      searchable do
        string :circulation_status do
          circulation_status.name
        end
      end
      accepts_nested_attributes_for :item_has_use_restriction
    end

    def set_circulation_status
      self.circulation_status = CirculationStatus.find_by(name: 'In Process') if circulation_status.nil?
    end

    def checkout_status(user)
      return nil unless user
      user.profile.user_group.user_group_has_checkout_types.find_by(checkout_type_id: checkout_type.id)
    end

    def reserved?
      return true if manifestation.next_reservation
      false
    end

    def rent?
      return true if checkouts.not_returned.select(:item_id).detect { |checkout| checkout.item_id == id }
      false
    end

    def reserved_by_user?(user)
      if manifestation.next_reservation
        return true if manifestation.next_reservation.user == user
      end
      false
    end

    def available_for_checkout?
      if circulation_status.name == 'On Loan'
        false
      else
        manifestation.items.for_checkout.include?(self)
      end
    end

    def checkin!
      self.circulation_status = CirculationStatus.find_by(name: 'Available On Shelf')
      save(validate: false)
    end

    def retain!(librarian)
      self.class.transaction do
        reservation = manifestation.next_reservation
        if reservation
          retain = Retain.create!(reserve: reservation, item: self)
          retain.send_message(librarian)
        end
      end
    end

    def retained?
      return true unless RetainAndCheckout.where(retain: retains).count == retains.count
      false
    end

    def not_for_loan?
      !manifestation.items.for_checkout.include?(self)
    end

    def next_reservation
      Reserve.waiting.find_by(item_id: id)
    end

    def latest_checkout
      checkouts.not_returned.order(created_at: :desc).first
    end
  end
end
