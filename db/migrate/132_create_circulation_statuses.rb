class CreateCirculationStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :circulation_statuses, comment: '貸出状態マスタ' do |t|
      t.string :name, null: false, comment: '貸出状態コード'
      t.text :display_name
      t.text :note, comment: '備考'
      t.integer :position, comment: '表示順序'

      t.timestamps
    end
  end
end
