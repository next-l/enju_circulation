class AddAcquiredAtToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :acquired_at, :timestamp
  end
end
