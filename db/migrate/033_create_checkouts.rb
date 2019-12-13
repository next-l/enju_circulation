class CreateCheckouts < ActiveRecord::Migration[5.2]
  def change
    create_table :checkouts, comment: '貸出' do |t|
      t.references :user, foreign_key: true, comment: '貸出対象者のユーザID'
      t.references :item, foreign_key: true, null: false, comment: '貸出資料の所蔵ID'
      t.references :librarian, comment: '貸出担当者のユーザID'
      t.references :basket, comment: '貸出セッションID'
      t.datetime :due_date, comment: '返却期限日'
      t.integer :checkout_renewal_count, default: 0, null: false, comment: '貸出更新回数'
      t.integer :lock_version, default: 0, null: false
      t.timestamps
    end
    add_index :checkouts, [:item_id, :basket_id], unique: true
  end
end
