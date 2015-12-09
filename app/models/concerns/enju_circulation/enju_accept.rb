module EnjuCirculation
  module EnjuAccept
    extend ActiveSupport::Concern

    included do
      before_save :accept!, on: :create
    end

    def accept!
      circulation_status = CirculationStatus.where(name: 'Available On Shelf').first
      item.update_column(:circulation_status_id, circulation_status.id) if circulation_status
      use_restriction = UseRestriction.where(name: 'Limited Circulation, Normal Loan Period').first
      item.use_restriction = use_restriction if use_restriction
    end
  end
end
