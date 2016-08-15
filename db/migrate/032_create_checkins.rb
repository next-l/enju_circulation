class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
      t.references :item, index: true, foreign_key: true, null: false
      t.references :librarian, index: true, foreign_key: {to_table: :users}, null: false
      t.references :basket, index: true, foreign_key: true
      t.timestamps
    end
  end

  def self.down
    drop_table :checkins
  end
end
