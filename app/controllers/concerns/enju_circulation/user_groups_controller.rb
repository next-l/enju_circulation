module EnjuCirculation
  module UserGroupsController
    extend ActiveSupport::Concern

    included do
      before_action :prepare_options, only: [:new, :edit]

      private

      def user_group_params
        params.require(:user_group).permit(
          :name, :display_name, :note, :valid_period_for_new_user,
          :expired_at, :number_of_day_to_notify_overdue,
          :number_of_day_to_notify_overdue,
          :number_of_day_to_notify_due_date,
          :number_of_time_to_notify_overdue,
          I18n.available_locales.map{|locale|
            :"display_name_#{locale.to_s}"
          },
          # EnjuCirculation
          {user_group_has_checkout_types_attributes: [
            :id, :checkout_type_id, :checkout_limit, :checkout_period, :checkout_renewal_limit,
            :reservation_limit, :reservation_expired_period, :set_due_date_before_closing_day
          ]},
        )
      end

      def prepare_options
        @checkout_types = CheckoutType.select([:id, :display_name, :position])
      end
    end
  end
end
