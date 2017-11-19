class AddAttachmentDataToEventImportFile < ActiveRecord::Migration[5.1]
  def change
    add_column :event_import_files, :attachment_data, :jsonb
  end
end
