module EnjuCirculation
  module EnjuWithdraw
    extend ActiveSupport::Concern

    included do
      before_save :withdraw!, on: :create
    end

    def withdraw!
      circulation_status = CirculationStatus.find_by(name: 'Removed')
      item.update_column(:circulation_status_id, circulation_status.id) if circulation_status
      item.use_restriction = UseRestriction.find_by(name: 'Not For Loan')
      item.index!
    end
  end
end
