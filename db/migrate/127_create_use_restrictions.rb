class CreateUseRestrictions < ActiveRecord::Migration[5.2]
  def self.up
    create_table :use_restrictions do |t|
      t.string :name, null: false
      t.text :display_name
      t.text :note, comment: '備考'
      t.integer :position, comment: '表示順序'

      t.timestamps
    end
  end

  def self.down
    drop_table :use_restrictions
  end
end
