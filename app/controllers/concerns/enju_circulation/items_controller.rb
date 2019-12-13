module EnjuCirculation
  module ItemsController
    extend ActiveSupport::Concern

    included do
      #private

      def prepare_options
        @circulation_statuses = CirculationStatus.order(:position)
        @use_restrictions = UseRestriction.available
        if @manifestation
          @checkout_types = CheckoutType.available_for_carrier_type(@manifestation.carrier_type)
        else
          @checkout_types = CheckoutType.order(:position)
        end

        super
      end
    end
  end
end
