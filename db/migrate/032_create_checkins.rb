class CreateCheckins < ActiveRecord::Migration[5.0]
  def change
    create_table :checkins do |t|
      t.references :item, foreign_key: true, null: false, type: :uuid
      t.references :librarian, foreign_key: {to_table: :users}, null: false
      t.references :basket, null: false
      t.timestamps
    end
  end
end
