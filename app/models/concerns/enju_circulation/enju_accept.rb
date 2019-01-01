module EnjuCirculation
  module EnjuAccept
    extend ActiveSupport::Concern

    included do
      after_save :accept!, on: :create
    end

    def accept!
      circulation_status = CirculationStatus.find_by(name: 'Available On Shelf')
      item.update!(circulation_status: circulation_status)
      use_restriction = UseRestriction.find_by(name: 'Limited Circulation, Normal Loan Period')
      item.use_restriction = use_restriction
    end
  end
end
