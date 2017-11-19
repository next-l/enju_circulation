class AddAttachmentDataToEventExportFile < ActiveRecord::Migration[5.1]
  def change
    add_column :event_export_files, :attachment_data, :jsonb
  end
end
