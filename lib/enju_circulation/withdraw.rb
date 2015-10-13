module EnjuCirculation
  module EnjuWithdraw
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_circulation_withdraw_model
        include InstanceMethods
        before_save :withdraw!, on: :create
      end
    end

    module InstanceMethods
      def withdraw!
        circulation_status = CirculationStatus.where(name: 'Removed').first
        item.circulation_status = circulation_status
        item.use_restriction = UseRestriction.where(name: 'Not For Loan').first
        item.index!
      end
    end
  end
end
