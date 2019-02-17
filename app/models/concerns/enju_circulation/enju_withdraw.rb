module EnjuCirculation
  module EnjuWithdraw
    extend ActiveSupport::Concern

    included do
      before_save :withdraw!, on: :create
    end

    def withdraw!
      item.update!(circulation_status: CirculationStatus.find_by(name: 'Removed'))
      item.use_restriction = UseRestriction.find_by(name: 'Not For Loan')
      item.index!
    end
  end
end
