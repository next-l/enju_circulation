class CreateReserves < ActiveRecord::Migration[5.2]
  def change
    create_table :reserves, comment: '予約' do |t|
      t.references :user, foreign_key: true, null: false, comment: '予約者のユーザID'
      t.references :manifestation, null: false, comment: '予約対象資料の書誌ID'
      t.references :item, comment: '予約対象資料の所蔵ID'
      t.references :request_status_type, null: false
      t.datetime :checked_out_at
      t.timestamps
      t.datetime :canceled_at
      t.datetime :expired_at
      t.boolean :expiration_notice_to_patron, default: false
      t.boolean :expiration_notice_to_library, default: false
    end
  end
end
