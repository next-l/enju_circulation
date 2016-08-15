class AddShelfIdToCheckout < ActiveRecord::Migration
  def change
    add_reference :checkouts, :shelf, index: true, foreign_key: true
  end
end
