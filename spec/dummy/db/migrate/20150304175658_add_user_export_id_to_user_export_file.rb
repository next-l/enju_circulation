class AddUserExportIdToUserExportFile < ActiveRecord::Migration[5.1]
  def change
    add_column :user_export_files, :user_export_id, :string
    add_column :user_export_files, :user_export_filename, :string
    add_column :user_export_files, :user_export_size, :integer
    add_column :user_export_files, :user_export_content_type, :string
    add_index :user_export_files, :user_export_id
  end
end
