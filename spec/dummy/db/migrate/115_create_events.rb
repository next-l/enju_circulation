class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :library, null: false, foreign_key: true, type: :uuid
      t.references :event_category, null: false, foreign_key: true
      t.string :name
      t.text :note
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day, default: false, null: false
      t.datetime :deleted_at
      t.jsonb :display_name_translations

      t.timestamps
    end
  end
end
