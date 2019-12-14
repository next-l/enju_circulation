class CreateUserReserveStats < ActiveRecord::Migration[5.2]
  def self.up
    create_table :user_reserve_stats do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.text :note, comment: '備考'

      t.timestamps
    end
  end

  def self.down
    drop_table :user_reserve_stats
  end
end
