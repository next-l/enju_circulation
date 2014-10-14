module EnjuCirculation
  module EnjuProfile
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_circulation_profile_model
        include InstanceMethods
        attr_accessible :save_checkout_history, :checkout_icalendar_token
        attr_accessible :save_checkout_history, :checkout_icalendar_token,
          as: :admin
      end
    end

    module InstanceMethods
      def reset_checkout_icalendar_token
        self.checkout_icalendar_token = Devise.friendly_token
      end

      def delete_checkout_icalendar_token
        self.checkout_icalendar_token = nil
      end
    end
  end
end
