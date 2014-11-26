module EnjuCirculation
  module EnjuAccept
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_circulation_accept_model
        include InstanceMethods
      end
    end

    module InstanceMethods
      def accept!
        circulation_status = CirculationStatus.where(name: 'Available On Shelf').first
        item.update_column(:circulation_status_id, circulation_status.id) if circulation_status
        use_restriction = UseRestriction.where(name: 'Limited Circulation, Normal Loan Period').first
        item.use_restriction = use_restriction if use_restriction
      end
    end
  end
end
