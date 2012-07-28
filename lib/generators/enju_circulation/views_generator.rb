module EnjuCirculation
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/views', __FILE__)

      def copy_files
        directories = %w(
          baskets
          carrier_type_has_checkout_types
          checked_items
          checkins
          checkout_stat_has_manifestations
          checkout_stat_has_users
          checkout_types
          checkouts
          circulation_statuses
          item_has_use_restrictions
          lending_policies
          manifestation_checkout_stats
          manifestation_reserve_stats
          reserve_stat_has_manifestations
          reserve_stat_has_users
          reserves
          use_restrictions
          user_checkout_stats
          user_group_has_checkout_types
          user_reserve_stats
        )

        directories.each do |dir|
          directory dir, "app/views/#{dir}"
        end
      end
    end
  end
end
