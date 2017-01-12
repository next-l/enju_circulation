class AddForeignKeyToProfilesReferencingUsers < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :profiles, :libraries, type: :uuid
    add_foreign_key :profiles, :user_groups, type: :uuid
  end
end
