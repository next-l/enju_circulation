class CreateParticipates < ActiveRecord::Migration[5.1]
  def self.up
    create_table :participates do |t|
      t.references :agent, null: false, index: true
      t.references :event, null: false, index: true
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :participates
  end
end
