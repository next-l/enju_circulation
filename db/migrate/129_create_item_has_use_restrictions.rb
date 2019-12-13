class CreateItemHasUseRestrictions < ActiveRecord::Migration[5.2]
  def change
    create_table :item_has_use_restrictions, comment: '所属と利用期限の関係' do |t|
      t.references :item, foreign_key: true, null: false, comment: '所蔵ID'
      t.references :use_restriction, foreign_key: true, null: false, comment: '利用制限ID'

      t.timestamps
    end
  end
end
