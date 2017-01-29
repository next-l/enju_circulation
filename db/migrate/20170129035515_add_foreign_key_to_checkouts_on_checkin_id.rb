class AddForeignKeyToCheckoutsOnCheckinId < ActiveRecord::Migration
  def change
    add_foreign_key :checkouts, :checkins
    add_foreign_key :checkouts, :users
    add_foreign_key :checkouts, :users, column: :librarian_id
  end
end
