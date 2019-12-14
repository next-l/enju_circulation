class CreateCarrierTypeHasCheckoutTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :carrier_type_has_checkout_types do |t|
      t.references :carrier_type, index: false, foreign_key: true, null: false
      t.references :checkout_type, foreign_key: true, null: false
      t.text :note, comment: '備考'
      t.integer :position, comment: '表示順序'

      t.timestamps
    end
    add_index :carrier_type_has_checkout_types, :carrier_type_id, name: 'index_carrier_type_has_checkout_types_on_m_form_id'
  end
end
