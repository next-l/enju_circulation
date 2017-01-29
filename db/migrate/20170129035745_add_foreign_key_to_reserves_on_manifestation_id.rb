class AddForeignKeyToReservesOnManifestationId < ActiveRecord::Migration
  def change
    add_foreign_key :reserves, :manifestations, null: false
    add_foreign_key :reserves, :items
    add_foreign_key :reserves, :users
    add_foreign_key :reserves, :users, column: :librarian_id
  end
end
