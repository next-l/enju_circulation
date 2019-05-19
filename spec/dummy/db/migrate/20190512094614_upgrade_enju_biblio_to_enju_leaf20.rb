class UpgradeEnjuBiblioToEnjuLeaf20 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up {
        change_table :agent_import_file_transitions do |t|
          t.change :agent_import_file_id, :bigint
        end

        change_table :agent_import_files do |t|
          t.change :user_id, :bigint
        end

        change_table :agent_import_results do |t|
          t.change :agent_id, :bigint
          t.change :agent_import_file_id, :bigint
        end

        change_table :agent_merges do |t|
          t.change :agent_id, :bigint
          t.change :agent_merge_list_id, :bigint
        end

        change_table :agent_relationships do |t|
          t.change :agent_relationship_type_id, :bigint
          t.change :child_id, :bigint, null: false
          t.change :parent_id, :bigint, null: false
        end

        change_table :agents do |t|
          t.change :profile_id, :bigint
        end

        change_table :carrier_type_has_checkout_types do |t|
          t.change :carrier_type_id, :bigint
          t.change :checkout_type_id, :bigint
        end

        change_table :creates do |t|
          t.change :agent_id, :bigint
          t.change :work_id, :bigint
        end

        change_table :donates do |t|
          t.change :agent_id, :bigint
          t.change :item_id, :bigint
        end

        change_table :identifiers do |t|
          t.change :identifier_type_id, :bigint
          t.change :manifestation_id, :bigint
        end

        change_table :import_request_transitions do |t|
          t.change :import_request_id, :bigint
        end

        change_table :import_requests do |t|
          t.change :manifestation_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :items do |t|
          t.change :bookstore_id, :bigint
          t.change :manifestation_id, :bigint
        end

        change_table :manifestation_relationships do |t|
          t.change :manifestation_relationship_type_id, :bigint
          t.change :child_id, :bigint, null: false
          t.change :parent_id, :bigint, null: false
        end

        change_table :owns do |t|
          t.change :agent_id, :bigint
          t.change :item_id, :bigint
        end

        change_table :picture_files do |t|
          t.change :picture_attachable_id, :bigint
        end

        change_table :produces do |t|
          t.change :agent_id, :bigint
          t.change :manifestation_id, :bigint
        end

        change_table :realizes do |t|
          t.change :agent_id, :bigint
          t.change :expression_id, :bigint
        end

        change_table :resource_export_file_transitions do |t|
          t.change :resource_export_file_id, :bigint
        end

        change_table :resource_export_files do |t|
          t.change :user_id, :bigint
        end

        change_table :resource_import_file_transitions do |t|
          t.change :resource_import_file_id, :bigint
        end

        change_table :resource_import_files do |t|
          t.change :default_shelf_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :resource_import_results do |t|
          t.change :item_id, :bigint
          t.change :manifestation_id, :bigint
          t.change :resource_import_file_id, :bigint
        end

        change_table :series_statement_merges do |t|
          t.change :series_statement_id, :bigint
          t.change :series_statement_merge_list_id, :bigint
        end

        change_table :series_statements do |t|
          t.change :manifestation_id, :bigint
          t.change :root_manifestation_id, :bigint
        end

        change_table :shelves do |t|
          t.change :library_id, :bigint
        end

        add_column :countries, :created_at, :timestamp # , null: false
        add_column :countries, :updated_at, :timestamp # , null: false
        add_column :languages, :created_at, :timestamp # , null: false
        add_column :languages, :updated_at, :timestamp # , null: false
        add_index :resource_import_files, :default_shelf_id
        add_index :resource_export_files, :user_id
        add_index :agent_import_results, :agent_id
        add_index :agent_import_results, :agent_import_file_id
        rename_index :manifestations, :index_carrier_type_has_checkout_types_on_m_form_id, :index_carrier_type_has_checkout_types_on_carrier_type_id
        remove_index :items, :item_identifier
        add_index :items, :item_identifier, unique: true
        add_index :manifestations, :carrier_type_id
        remove_index :manifestations, :manifestation_identifier
        add_index :manifestations, :manifestation_identifier, unique: true

        change_column_null :agent_import_results, :agent_import_file_id, false
        change_column_null :identifiers, :manifestation_id, false
        change_column_null :import_requests, :isbn, false
        change_column_null :picture_files, :picture_attachable_id, false
        change_column_null :picture_files, :picture_attachable_type, false
        change_column_null :series_statements, :original_title, false
        [
          :create_types,
          :identifier_types,
          :realize_types,
          :produce_types,
        ].each do |table|
          change_column_null table, :name, false
        end

        add_foreign_key :agent_import_results, :agent_import_files
        add_foreign_key :agent_merges, :agents
        add_foreign_key :agent_relationships, :agents, column: :child_id
        add_foreign_key :agent_relationships, :agents, column: :parent_id
        add_foreign_key :agents, :profiles
        add_foreign_key :creates, :agents
        add_foreign_key :creates, :manifestations, column: :work_id
        add_foreign_key :donates, :agents
        add_foreign_key :donates, :items
        add_foreign_key :identifiers, :identifier_types
        add_foreign_key :items, :bookstores
        add_foreign_key :items, :checkout_types
        add_foreign_key :items, :circulation_statuses
        add_foreign_key :manifestation_relationships, :manifestations, column: :child_id
        add_foreign_key :manifestation_relationships, :manifestations, column: :parent_id
        add_foreign_key :manifestations, :carrier_types
        add_foreign_key :produces, :agents
        add_foreign_key :realizes, :agents
        add_foreign_key :realizes, :manifestations, column: :expression_id
        add_foreign_key :resource_import_files, :shelves, column: :default_shelf_id
        add_foreign_key :resource_import_results, :resource_import_files
        add_foreign_key :series_statement_merges, :series_statement_merge_lists
        add_foreign_key :series_statement_merges, :series_statements
      }

      dir.down {
        change_table :agent_import_file_transitions do |t|
          t.change :agent_import_file_id, :integer
        end

        change_table :agent_import_files do |t|
          t.change :user_id, :integer
        end

        change_table :agent_import_results do |t|
          t.change :agent_id, :integer
          t.change :agent_import_file_id, :integer
        end

        change_table :agent_relationships do |t|
          t.change :agent_relationship_type_id, :integer
          t.change :child_id, :integer
          t.change :parent_id, :integer
        end

        change_table :agents do |t|
          t.change :profile_id, :integer
        end

        change_table :agent_merges do |t|
          t.change :agent_id, :integer
          t.change :agent_merge_list_id, :integer
        end

        change_table :carrier_type_has_checkout_types do |t|
          t.change :carrier_type_id, :integer
          t.change :checkout_type_id, :integer
        end

        change_table :donates do |t|
          t.change :agent_id, :integer
          t.change :item_id, :integer
        end

        change_table :identifiers do |t|
          t.change :identifier_type_id, :integer
          t.change :manifestation_id, :integer
        end

        change_table :import_request_transitions do |t|
          t.change :import_request_id, :integer
        end

        change_table :import_requests do |t|
          t.change :manifestation_id, :integer
          t.change :user_id, :integer
        end

        change_table :items do |t|
          t.change :bookstore_id, :integer
          t.change :manifestation_id, :integer
        end

        change_table :manifestation_relationships do |t|
          t.change :manifestation_relationship_type_id, :integer
          t.change :child_id, :integer
          t.change :parent_id, :integer
        end

        change_table :owns do |t|
          t.change :agent_id, :integer
          t.change :item_id, :integer
        end

        change_table :picture_files do |t|
          t.change :picture_attachable_id, :integer
        end

        change_table :produces do |t|
          t.change :agent_id, :integer
          t.change :manifestation_id, :integer
        end

        change_table :realizes do |t|
          t.change :agent_id, :integer
          t.change :expression_id, :integer
        end

        change_table :resource_export_file_transitions do |t|
          t.change :resource_export_file_id, :integer
        end

        change_table :resource_export_files do |t|
          t.change :user_id, :integer
        end

        change_table :resource_import_file_transitions do |t|
          t.change :resource_import_file_id, :integer
        end

        change_table :resource_import_files do |t|
          t.change :default_shelf_id, :integer
          t.change :user_id, :integer
        end

        change_table :resource_import_results do |t|
          t.change :item_id, :integer
          t.change :manifestation_id, :integer
          t.change :resource_import_file_id, :integer
        end

        change_table :series_statement_merges do |t|
          t.change :series_statement_id, :integer
          t.change :series_statement_merge_list_id, :integer
        end

        change_table :series_statements do |t|
          t.change :manifestation_id, :integer
          t.change :root_manifestation_id, :integer
        end

        change_table :shelves do |t|
          t.change :library_id, :integer
        end

        rename_index :manifestations, :index_carrier_type_has_checkout_types_on_carrier_type_id, :index_carrier_type_has_checkout_types_on_m_form_id
        remove_index :resource_export_files, :user_id
        remove_index :resource_import_files, :default_shelf_id
        remove_index :agent_import_results, :agent_id
        remove_index :agent_import_results, :agent_import_file_id
        remove_index :items, :item_identifier
        add_index :items, :item_identifier
        remove_index :manifestations, :carrier_type_id
        remove_index :manifestations, :manifestation_identifier
        add_index :manifestations, :manifestation_identifier

        remove_column :countries, :created_at
        remove_column :countries, :updated_at
        remove_column :languages, :created_at
        remove_column :languages, :updated_at

        remove_foreign_key :agent_import_results, :agent_import_files
        remove_foreign_key :agent_merges, :agents
        remove_foreign_key :agent_relationships, :agents
        remove_foreign_key :agent_relationships, :agents
        remove_foreign_key :agents, :profiles
        remove_foreign_key :creates, :agents
        remove_foreign_key :creates, :manifestations
        remove_foreign_key :donates, :agents
        remove_foreign_key :donates, :items
        remove_foreign_key :identifiers, :identifier_types
        remove_foreign_key :items, :bookstores
        remove_foreign_key :items, :checkout_types
        remove_foreign_key :items, :circulation_statuses
        remove_foreign_key :manifestation_relationships, :manifestations
        remove_foreign_key :manifestation_relationships, :manifestations
        remove_foreign_key :manifestations, :carrier_types
        remove_foreign_key :produces, :agents
        remove_foreign_key :realizes, :agents
        remove_foreign_key :realizes, :manifestations
        remove_foreign_key :resource_import_files, :shelves
        remove_foreign_key :resource_import_results, :resource_import_files
        remove_foreign_key :series_statement_merges, :series_statement_merge_lists
        remove_foreign_key :series_statement_merges, :series_statements
      }

      [
        :agent_types,
        :carrier_types,
        :content_types,
        :create_types,
        :creates,
        :form_of_works,
        :frequencies,
        :identifier_types,
        :licenses,
        :owns,
        :produce_types,
        :produces,
        :realize_types,
        :realizes,
      ].each do |table|
        change_column_null table, :position, false
        dir.up { change_column table, :position, :integer, default: 1 }
        dir.down { change_column table, :position, :integer, default: nil }
      end

      [
        :carrier_types,
        :identifier_types,
      ].each do |table|
        dir.up { add_index table.to_sym, :name, unique: true }
        dir.down { remove_index table.to_sym, :name }
      end

      [
        :agent_import_files,
        :import_requests,
        :resource_export_files,
        :resource_import_files,
      ].each do |table|
        dir.up {
          add_foreign_key table, :users
        }
        dir.down {
          remove_foreign_key table, :users
        }
      end

      [
        :identifiers,
        :import_requests,
        :produces,
        :series_statements,
      ].each do |table|
        dir.up {
          add_foreign_key table, :manifestations
        }
        dir.down {
          remove_foreign_key table, :manifestations
        }
      end
    end
  end
end
