module EnjuCirculation
  module ItemsController
    extend ActiveSupport::Concern

    included do
      private

      def prepare_options
        @libraries = Library.order(:position)
        if @item
          @library = @item.shelf.library
        else
          @library = Library.real.includes(:shelves).order(:position).first
        end
        @shelves = @library&.shelves
        @bookstores = Bookstore.order(:position)
        @budget_types = BudgetType.order(:position)
        @roles = Role.all
        @circulation_statuses = CirculationStatus.order(:position)
        @use_restrictions = UseRestriction.available
        if @manifestation
          @checkout_types = CheckoutType.available_for_carrier_type(@manifestation.carrier_type)
        else
          @checkout_types = CheckoutType.order(:position)
        end
      end
    end
  end
end
