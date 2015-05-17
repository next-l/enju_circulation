module EnjuCirculation
  module EnjuProfile
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_circulation_profile_model
        include InstanceMethods
      end
    end

    module InstanceMethods
      def reset_checkout_icalendar_token
        self.checkout_icalendar_token = SecureRandom.hex(16)
      end

      def delete_checkout_icalendar_token
        self.checkout_icalendar_token = nil
      end
    end
  end
end
