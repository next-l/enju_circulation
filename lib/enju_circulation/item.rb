module EnjuCirculation
  module EnjuItem
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      FOR_CHECKOUT_CIRCULATION_STATUS = [
        'Available On Shelf',
        'On Loan',
        'Waiting To Be Reshelved'
      ]
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
      ]

      def enju_circulation_item_model
        include InstanceMethods
        has_many :reserves, :foreign_key => :manifestation_id

        scope :for_checkout, includes(:circulation_status, :use_restriction).where(
            'circulation_statuses.name' => FOR_CHECKOUT_CIRCULATION_STATUS,
            'use_restrictions.name' => FOR_CHECKOUT_USE_RESTRICTION
          ).where('item_identifier IS NOT NULL')
        scope :removed, includes(:circulation_status).where('circulation_statuses.name' => 'Removed')
        has_many :checkouts
        has_many :reserves
        has_many :checked_items, :dependent => :destroy
        has_many :baskets, :through => :checked_items
        belongs_to :circulation_status, :validate => true
        belongs_to :checkout_type
        has_many :lending_policies, :dependent => :destroy
        has_one :item_has_use_restriction, :dependent => :destroy
        has_one :use_restriction, :through => :item_has_use_restriction
        validates_associated :circulation_status, :checkout_type
        validates_presence_of :circulation_status, :checkout_type
        searchable do
          integer :circulation_status_id
        end
        attr_accessible :item_has_use_restriction_attributes
        accepts_nested_attributes_for :item_has_use_restriction

        after_create :create_lending_policy
        before_update :update_lending_policy
      end
    end

    module InstanceMethods
      def set_circulation_status
        self.circulation_status = CirculationStatus.where(:name => 'In Process').first if self.circulation_status.nil?
      end

      def checkout_status(user)
        return nil unless user
         user.user_group.user_group_has_checkout_types.where(:checkout_type_id => self.checkout_type.id).first
      end

      def reserved?
        return true if manifestation.next_reservation
        false
      end

      def rent?
        return true if self.checkouts.not_returned.select(:item_id).detect{|checkout| checkout.item_id == self.id}
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
        self.circulation_status = CirculationStatus.where(:name => 'On Loan').first
        if self.reserved_by_user?(user)
          manifestation.next_reservation.update_attributes(:checked_out_at => Time.zone.now)
          manifestation.next_reservation.sm_complete!
        end
        save!
      end

      def checkin!
        self.circulation_status = CirculationStatus.where(:name => 'Available On Shelf').first
        save(:validate => false)
      end

      def retain(librarian)
        self.class.transaction do
          reservation = manifestation.next_reservation
          unless reservation.nil?
            reservation.item = self
            reservation.sm_retain!
            reservation.send_message(librarian)
          end
        end
      end

      def retained?
        if manifestation.next_reservation.try(:state) == 'retained' and  manifestation.next_reservation.item == self
          return true
        else
          false
        end
      end

      def lending_rule(user)
        lending_policies.where(:user_group_id => user.user_group.id).first
      end

      def not_for_loan?
        !manifestation.items.for_checkout.include?(self)
      end

     def create_lending_policy
        UserGroupHasCheckoutType.available_for_item(self).each do |rule|
          LendingPolicy.create!(:item_id => id, :user_group_id => rule.user_group_id, :fixed_due_date => rule.fixed_due_date, :loan_period => rule.checkout_period, :renewal => rule.checkout_renewal_limit)
        end
      end

      def update_lending_policy
        return nil unless changes[:checkout_type_id]
        self.transaction do
          lending_policies.delete_all
          create_lending_policy
        end
      end

      def next_reservation
        Reserve.waiting.where(:item_id => id).first
      end
    end
  end
end
