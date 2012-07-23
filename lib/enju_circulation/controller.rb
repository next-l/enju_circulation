module EnjuCirculation
  module Controller
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def enju_circulation
        include InstanceMethods
      end
    end

    module InstanceMethods
      private

      def get_checkout_type
        @checkout_type = CheckoutType.find(params[:checkout_type_id]) if params[:checkout_type_id]
      end
    end
  end
end
