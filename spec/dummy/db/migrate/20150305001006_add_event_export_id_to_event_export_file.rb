class AddEventExportIdToEventExportFile < ActiveRecord::Migration
  def change
    add_column :event_export_files, :event_export_id, :string
    add_column :event_export_files, :event_export_file_name, :string
    add_column :event_export_files, :event_export_size, :integer
    add_column :event_export_files, :event_export_content_type, :string
    add_index :event_export_files, :event_export_id
  end
end
