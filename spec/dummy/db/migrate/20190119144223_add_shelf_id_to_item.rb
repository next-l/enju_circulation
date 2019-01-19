class AddShelfIdToItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :shelf, foreign_key: true, null: false
  end
end
