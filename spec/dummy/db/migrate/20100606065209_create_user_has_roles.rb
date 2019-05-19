class CreateUserHasRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :user_has_roles do |t|
      t.references :user, foreign_key: true, null: false
      t.references :role, foreign_key: true, null: false

      t.timestamps
    end
    add_index :user_has_roles, [:user_id, :role_id], unique: true
  end
end
