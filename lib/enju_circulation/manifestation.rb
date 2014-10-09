module EnjuCirculation
  module EnjuManifestation
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_circulation_manifestation_model
        include InstanceMethods
        has_many :reserves, :foreign_key => :manifestation_id

        settings do
          mappings dynamic: 'false', _routing: {required: false} do
            indexes :reservable, type: 'boolean'
          end
        end
      end
    end

    module InstanceMethods
      def as_indexed_json(options={})
        super.merge(
          reservable: items.for_checkout.exists?
        )
      end

      def next_reservation
        self.reserves.waiting.order('reserves.created_at ASC').readonly(false).first
      end

      def available_checkout_types(user)
        if user
          user.profile.user_group.user_group_has_checkout_types.available_for_carrier_type(self.carrier_type)
        end
      end

      def is_reservable_by?(user)
        return false if items.for_checkout.empty?
        unless user.has_role?('Librarian')
          unless items.size == (items.size - user.checkouts.overdue(Time.zone.now).collect(&:item).size)
            return false
          end
        end
        true
      end

      def is_reserved_by?(user)
        return nil unless user
        reserve = Reserve.waiting.where(:user_id => user.id, :manifestation_id => id).first
        if reserve
          reserve
        else
          false
        end
      end

      def is_reserved?
        if self.reserves.present?
          true
        else
          false
        end
      end

      def checkouts(start_date, end_date)
        Checkout.completed(start_date, end_date).where(:item_id => self.items.collect(&:id))
      end

      def checkout_period(user)
        if available_checkout_types(user)
          available_checkout_types(user).collect(&:checkout_period).max || 0
        end
      end

      def reservation_expired_period(user)
        if available_checkout_types(user)
          available_checkout_types(user).collect(&:reservation_expired_period).max || 0
        end
      end

      def is_checked_out_by?(user)
        if items.size > items.size - user.checkouts.not_returned.collect(&:item).size
          true
        else
          false
        end
      end
    end
  end
end
