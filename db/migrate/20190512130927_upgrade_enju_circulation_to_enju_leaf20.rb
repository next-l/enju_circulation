class UpgradeEnjuCirculationToEnjuLeaf20 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up {
        change_table :checked_items do |t|
          t.change :basket_id, :bigint
          t.change :item_id, :bigint
          t.change :librarian_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :checkins do |t|
          t.change :basket_id, :bigint
          t.change :librarian_id, :bigint
          t.references :checkout, foreign_key: true
        end

        change_table :checkout_stat_has_manifestations do |t|
          t.change :manifestation_checkout_stat_id, :bigint
          t.change :manifestation_id, :bigint
        end

        change_table :checkout_stat_has_users do |t|
          t.change :user_checkout_stat_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :checkouts do |t|
          t.change :basket_id, :bigint
          t.change :item_id, :bigint
          t.change :librarian_id, :bigint
          t.change :library_id, :bigint
          t.change :shelf_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :demands do |t|
          t.change :item_id, :bigint
          t.change :user_id, :bigint
          t.change :message_id, :bigint
        end

        change_table :item_has_use_restrictions do |t|
          t.change :item_id, :bigint
          t.change :use_restriction_id, :bigint
        end

        change_table :manifestation_checkout_stat_transitions do |t|
          t.change :manifestation_checkout_stat_id, :bigint
        end

        change_table :manifestation_checkout_stats do |t|
          t.change :user_id, :bigint
        end

        change_table :manifestation_reserve_stat_transitions do |t|
          t.change :manifestation_reserve_stat_id, :bigint
        end

        change_table :manifestation_reserve_stats do |t|
          t.change :user_id, :bigint
        end

        change_table :reserve_stat_has_manifestations do |t|
          t.change :manifestation_reserve_stat_id, :bigint
          t.change :manifestation_id, :bigint
        end

        change_table :reserve_stat_has_users do |t|
          t.change :user_reserve_stat_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :reserve_transitions do |t|
          t.change :reserve_id, :bigint
        end

        change_table :reserves do |t|
          t.change :item_id, :bigint
          t.change :pickup_location_id, :bigint
          t.change :manifestation_id, :bigint
          t.change :request_status_type_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :user_checkout_stat_transitions do |t|
          t.change :user_checkout_stat_id, :bigint
        end

        change_table :user_checkout_stats do |t|
          t.change :user_id, :bigint
        end

        change_table :user_group_has_checkout_types do |t|
          t.change :checkout_type_id, :bigint
          t.change :user_group_id, :bigint
        end

        change_table :user_reserve_stat_transitions do |t|
          t.change :user_reserve_stat_id, :bigint
        end

        change_table :user_reserve_stats do |t|
          t.change :user_id, :bigint
        end

        remove_index :checkout_types, :name
        add_index :checkout_types, :name, unique: true
        add_index :reserves, :request_status_type_id

        add_foreign_key :checkouts, :users, column: :librarian_id
        add_foreign_key :reserves, :items
        add_foreign_key :reserves, :libraries, column: :pickup_location_id
      }

      dir.down {
        change_table :checked_items do |t|
          t.change :basket_id, :integer
          t.change :item_id, :integer
          t.change :item_id, :integer
          t.change :user_id, :integer
        end

        change_table :checkins do |t|
          t.change :basket_id, :integer
          t.change :librarian_id, :integer
          t.remove_references :checkout
        end

        change_table :checkout_stat_has_manifestations do |t|
          t.change :manifestation_checkout_stat_id, :integer
          t.change :manifestation_id, :integer
        end

        change_table :checkout_stat_has_users do |t|
          t.change :user_checkout_stat_id, :integer
          t.change :user_id, :integer
        end

        change_table :checkouts do |t|
          t.change :basket_id, :integer
          t.change :item_id, :integer
          t.change :librarian_id, :integer
          t.change :library_id, :integer
          t.change :shelf_id, :integer
          t.change :user_id, :integer
        end

        change_table :demands do |t|
          t.change :item_id, :integer
          t.change :user_id, :integer
          t.change :message_id, :integer
        end

        change_table :item_has_use_restrictions do |t|
          t.change :item_id, :integer
          t.change :use_restriction_id, :integer
        end

        change_table :manifestation_checkout_stat_transitions do |t|
          t.change :manifestation_checkout_stat_id, :integer
        end

        change_table :manifestation_checkout_stats do |t|
          t.change :user_id, :integer
        end

        change_table :manifestation_reserve_stat_transitions do |t|
          t.change :manifestation_reserve_stat_id, :integer
        end

        change_table :manifestation_reserve_stats do |t|
          t.change :user_id, :integer
        end

        change_table :reserve_stat_has_manifestations do |t|
          t.change :manifestation_reserve_stat_id, :integer
          t.change :manifestation_id, :integer
        end

        change_table :reserve_stat_has_users do |t|
          t.change :user_reserve_stat_id, :integer
          t.change :user_id, :integer
        end

        change_table :reserve_transitions do |t|
          t.change :reserve_id, :integer
        end

        change_table :reserves do |t|
          t.change :item_id, :integer
          t.change :pickup_location_id, :integer
          t.change :manifestation_id, :integer
          t.change :request_status_type_id, :integer
          t.change :user_id, :integer
        end

        change_table :user_checkout_stat_transitions do |t|
          t.change :user_checkout_stat_id, :integer
        end

        change_table :user_checkout_stats do |t|
          t.change :user_id, :integer
        end

        change_table :user_group_has_checkout_types do |t|
          t.change :checkout_type_id, :integer
          t.change :user_group_id, :integer
        end

        change_table :user_reserve_stat_transitions do |t|
          t.change :user_reserve_stat_id, :integer
        end

        change_table :user_reserve_stats do |t|
          t.change :user_id, :integer
        end

        remove_index :checkout_types, :name
        add_index :checkout_types, :name
        remove_index :reserves, :request_status_type_id

        remove_foreign_key :checkouts, :users
        remove_foreign_key :reserves, :items
        remove_foreign_key :reserves, :libraries
      }

      [
        :checkout_types,
      ].each do |table|
        change_column_null table, :position, false
        dir.up { change_column table, :position, :integer, default: 1 }
        dir.down { change_column table, :position, :integer, default: nil }
      end

      [
        :circulation_statuses,
        :use_restrictions,
      ].each do |table|
        dir.up { add_index table.to_sym, :name, unique: true }
        dir.down { remove_index table.to_sym, :name }
      end
    end
  end
end
