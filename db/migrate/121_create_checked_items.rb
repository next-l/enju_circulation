class CreateCheckedItems < ActiveRecord::Migration[5.2]
  def change
    create_table :checked_items do |t|
      t.references :item, foreign_key: true, null: false, comment: '貸出予定資料ID'
      t.references :basket, foreign_key: true, null: false, comment: '貸出セッションID'
      t.references :librarian, comment: '貸出担当者ユーザID'
      t.datetime :due_date, null: false, comment: '貸出期限予定日（貸出時に上書き可能）'

      t.timestamps
    end
  end
end
