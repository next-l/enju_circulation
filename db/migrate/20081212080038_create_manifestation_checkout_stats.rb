class CreateManifestationCheckoutStats < ActiveRecord::Migration
  def self.up
    create_table :manifestation_checkout_stats do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.text :note
      t.string :state
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
    add_index :manifestation_checkout_stats, :state
  end

  def self.down
    drop_table :manifestation_checkout_stats
  end
end
