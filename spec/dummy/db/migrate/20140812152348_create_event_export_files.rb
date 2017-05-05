class CreateEventExportFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :event_export_files do |t|
      t.references :user, index: true
      t.datetime :executed_at

      t.timestamps
    end
  end
end
