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
        item.update_column(:circulation_status_id, circulation_status.id) if circulation_status
        item.index!
      end
    end
  end
end
