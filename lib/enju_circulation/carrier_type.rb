module EnjuCirculation
  module EnjuCarrierType
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def enju_circulation_carrier_type_model
        has_many :carrier_type_has_checkout_types, dependent: :destroy
        has_many :checkout_types, through: :carrier_type_has_checkout_types
        accepts_nested_attributes_for :carrier_type_has_checkout_types, allow_destroy: true, reject_if: :all_blank
      end
    end
  end
end
