class AddLibrarianIdToCheckedItem < ActiveRecord::Migration
  def change
    add_reference :checked_items, :user, index: true, foreign_key: true, column_name: :librarian_id
  end
end
