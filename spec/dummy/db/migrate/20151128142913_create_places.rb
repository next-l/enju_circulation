class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :term, index: true
      t.text :city
      t.integer :country_id, index: true
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
