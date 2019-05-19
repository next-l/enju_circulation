class UpgradeEnjuSeedToEnjuLeaf20 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up {
        change_table :profiles do |t|
          t.change :library_id, :bigint
          t.change :required_role_id, :bigint
          t.change :user_group_id, :bigint
        end

        change_table :user_has_roles do |t|
          t.change :role_id, :bigint
          t.change :user_id, :bigint
        end

        change_table :users do |t|
          t.references :profile, index: {unique: true} #, foreign_key: {on_delete: :cascade}
        end

        add_index :roles, :name, unique: true
        change_column :roles, :position, :integer, default: 1

        add_foreign_key :profiles, :libraries
        add_foreign_key :profiles, :user_groups
      }

      dir.down {
        change_table :profiles do |t|
          t.change :library_id, :integer
          t.change :required_role_id, :integer
          t.change :user_group_id, :integer
        end

        change_table :user_has_roles do |t|
          t.change :role_id, :integer
          t.change :user_id, :integer
        end

        change_table :users do |t|
          t.change :id, :bigint
          t.change :id, :integer
          t.remove_references :profile
        end

        remove_index :roles, :name
        change_column :roles, :position, :integer, default: nil

        remove_foreign_key :profiles, :libraries
        remove_foreign_key :profiles, :user_groups
      }
    end

    change_column_null :profiles, :required_role_id, false
    change_column_null :profiles, :user_group_id, false
    change_column_null :roles, :position, false
  end
end
