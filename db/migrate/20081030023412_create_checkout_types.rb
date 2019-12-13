class CreateCheckoutTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :checkout_types, comment: '貸出区分' do |t|
      t.string :name, null: false, comment: '貸出区分コード'
      t.text :display_name, comment: '表示名称'
      t.text :note, comment: '備考'
      t.integer :position, comment: '表示順序'

      t.timestamps
    end
    add_index :checkout_types, :name
  end
end
