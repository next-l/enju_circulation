class AddForeignKeyToItemReferencingCheckout < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :checkouts, :items
  end
end
