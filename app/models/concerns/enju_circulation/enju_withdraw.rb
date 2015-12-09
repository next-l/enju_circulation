module EnjuCirculation
  module EnjuWithdraw
    extend ActiveSupport::Concern

    included do
      before_save :withdraw!, on: :create
    end

    def withdraw!
      circulation_status = CirculationStatus.where(name: 'Removed').first
      item.update_column(:circulation_status_id, circulation_status.id) if circulation_status
      item.use_restriction = UseRestriction.where(name: 'Not For Loan').first
      item.index!
    end
  end
end
