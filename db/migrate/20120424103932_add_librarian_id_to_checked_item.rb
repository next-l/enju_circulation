class AddLibrarianIdToCheckedItem < ActiveRecord::Migration
  def change
    add_reference :checked_items, :librarian, index: true, foreign_key: true
  end
end
