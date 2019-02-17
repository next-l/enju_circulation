module EnjuCirculation
  module EnjuWithdraw
    extend ActiveSupport::Concern

    included do
      before_save :withdraw!, on: :create
    end

    def withdraw!
      item.update_column(:circulation_status_id, CirculationStatus.find_by(name: 'Removed').id)
      item.use_restriction = UseRestriction.find_by(name: 'Not For Loan')
      item.index!
    end
  end
end
