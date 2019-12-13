module EnjuCirculation
  module CarrierTypesController
    extend ActiveSupport::Concern

    included do
      before_action :prepare_options, only: [:new, :edit]

      private

      def carrier_type_params
        params.require(:carrier_type).permit(
          :name, :display_name, :note, :position,
          :attachment,
          # EnjuCirculation
          {
            carrier_type_has_checkout_types_attributes: [
              :id, :checkout_type_id, :_destroy
            ]
          }
        )
      end

      def prepare_options
        @checkout_types = CheckoutType.select([:id, :display_name, :position])
      end
    end
  end
end
