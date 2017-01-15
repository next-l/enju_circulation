class AddEventImportIdToEventImportFile < ActiveRecord::Migration
  def change
    add_column :event_import_files, :event_import_id, :string
    rename_column :event_import_files, :event_import_file_size, :event_import_size
    add_index :event_import_files, :event_import_id
  end
end
