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
      has_many :lending_policies, dependent: :destroy
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

      before_update :delete_lending_policy
    end

    def set_circulation_status
      self.circulation_status = CirculationStatus.where(name: 'In Process').first if circulation_status.nil?
    end

    def checkout_status(user)
      return nil unless user
      user.profile.user_group.user_group_has_checkout_types.where(checkout_type_id: checkout_type.id).first
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

    def checkout!(user)
      self.circulation_status = CirculationStatus.where(name: 'On Loan').first
      if reserved_by_user?(user)
        manifestation.next_reservation.transition_to!(:completed)
      end
      manifestation.reload
      save!
    end

    def checkin!
      self.circulation_status = CirculationStatus.where(name: 'Available On Shelf').first
      save(validate: false)
    end

    def retain(librarian)
      self.class.transaction do
        reservation = manifestation.next_reservation
        if reservation
          reservation.item = self
          reservation.transition_to!(:retained) unless reservation.retained?
          reservation.send_message(librarian)
        end
      end
    end

    def retained?
      manifestation.reserves.in_state(:retained).each do |reserve|
        return true if reserve.item == self
      end
      false
    end

    def lending_rule(user)
      policy = lending_policies.where(user_group_id: user.profile.user_group.id).first
      if policy
        policy
      else
        create_lending_policy(user)
      end
    end

    def not_for_loan?
      !manifestation.items.for_checkout.include?(self)
    end

    def create_lending_policy(user)
      rule = user.profile.user_group.user_group_has_checkout_types.where(checkout_type_id: checkout_type_id).first
      return nil unless rule
      LendingPolicy.create!(
        item_id: id,
        user_group_id: rule.user_group_id,
        fixed_due_date: rule.fixed_due_date,
        loan_period: rule.checkout_period,
        renewal: rule.checkout_renewal_limit
      )
    end

    def delete_lending_policy
      return nil unless changes[:checkout_type_id]
      lending_policies.delete_all
    end

    def next_reservation
      Reserve.waiting.where(item_id: id).first
    end

    def latest_checkout
      checkouts.order('checkouts.id').first
    end
  end
end
