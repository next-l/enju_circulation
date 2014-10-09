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
        include Statesman::Adapters::ActiveRecordModel
        include InstanceMethods
        has_many :reserves, :foreign_key => :manifestation_id

        scope :for_checkout, -> { includes(:circulation_status, :use_restriction).where(
            'circulation_statuses.name' => FOR_CHECKOUT_CIRCULATION_STATUS,
            'use_restrictions.name' => FOR_CHECKOUT_USE_RESTRICTION
          ).where('item_identifier IS NOT NULL') }
        scope :removed, -> { includes(:circulation_status).where('circulation_statuses.name' => 'Removed') }
        has_many :checkouts
        has_many :reserves
        has_many :checked_items
        has_many :baskets, :through => :checked_items
        belongs_to :circulation_status, :validate => true
        belongs_to :checkout_type
        has_many :lending_policies, :dependent => :destroy
        has_one :item_has_use_restriction, :dependent => :destroy
        has_one :use_restriction, :through => :item_has_use_restriction
        validates_associated :circulation_status, :checkout_type
        validates_presence_of :circulation_status, :checkout_type
        settings do
          mappings dynamic: 'false', _routing: {required: false} do
            indexes :circulation_status_id, type: 'integer'
          end
        end
        #attr_accessible :item_has_use_restriction_attributes
        accepts_nested_attributes_for :item_has_use_restriction

        after_create :create_lending_policy
        before_update :update_lending_policy
        has_many :item_transitions

        delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
          to: :state_machine
      end

      private
      def transition_class
        ItemTransition
      end
    end

    module InstanceMethods
      def state_machine
        @state_machine ||= ItemStateMachine.new(self, transition_class: ItemTransition)
      end

      def checkout_status(user)
        return nil unless user
         user.profile.user_group.user_group_has_checkout_types.where(:checkout_type_id => self.checkout_type.id).first
      end

      def reserved?
        return true if manifestation.next_reservation
        false
      end

      def rent?
        return true if checkouts.not_returned.select(:item_id).detect{|checkout| checkout.item_id == self.id}
        false
      end

      def reserved_by_user?(user)
        if manifestation.next_reservation
          return true if manifestation.next_reservation.user == user
        end
        false
      end

      def available_for_checkout?
        if current_state == 'on_loan'
          false
        else
          manifestation.items.for_checkout.include?(self)
        end
      end

      def checkout!(user)
        self.class.transaction do
          transition_to(:on_loan)
          if reserved_by_user?(user)
            manifestation.next_reservation.update_attributes(:checked_out_at => Time.zone.now)
            manifestation.next_reservation.transition_to!(:completed)
          end
          save!
        end
      end

      def checkin!
        transition_to!(:available_on_shelf)
        save(:validate => false)
      end

      def retain(librarian)
        self.class.transaction do
          reservation = manifestation.next_reservation
          unless reservation.nil?
            reservation.item = self
            reservation.transition_to!(:retained)
            reservation.send_message(librarian)
          end
        end
      end

      def retained?
        if manifestation.next_reservation.try(:current_state) == 'retained' and  manifestation.next_reservation.item == self
          true
        else
          false
        end
      end

      def lending_rule(user)
        lending_policies.where(:user_group_id => user.profile.user_group.id).first
      end

      def not_for_loan?
        !manifestation.items.for_checkout.include?(self)
      end

     def create_lending_policy
        UserGroupHasCheckoutType.available_for_item(self).each do |rule|
          LendingPolicy.create!(
            :item_id => id, :user_group_id => rule.user_group_id,
            :fixed_due_date => rule.fixed_due_date,
            :loan_period => rule.checkout_period,
            :renewal => rule.checkout_renewal_limit
          )
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

      def latest_checkout
        checkouts.order('checkouts.id').first
      end
    end
  end
end
