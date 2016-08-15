class AddLibraryIdToCheckout < ActiveRecord::Migration
  def change
    add_reference :checkouts, :library, index: true, foreign_key: true
  end
end
