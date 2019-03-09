class CreateEventImportResults < ActiveRecord::Migration[5.2]
  def change
    create_table :event_import_results do |t|
      t.references :event_import_file, type: :uuid
      t.references :event, type: :uuid
      t.text :body

      t.timestamps
    end
  end
end
