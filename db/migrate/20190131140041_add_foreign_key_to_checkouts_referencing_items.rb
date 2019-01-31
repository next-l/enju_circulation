class AddForeignKeyToCheckoutsReferencingItems < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :checkouts, :items, null: false
  end
end
