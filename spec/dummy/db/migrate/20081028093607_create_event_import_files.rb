class CreateEventImportFiles < ActiveRecord::Migration
  def self.up
    create_table :event_import_files do |t|
      t.integer :parent_id
      t.string :content_type
      t.integer :size
      t.references :user, index: true
      t.text :note
      t.datetime :imported_at
      t.string :event_import_filename
      t.string :event_import_content_type
      t.integer :event_import_file_size
      t.datetime :event_import_updated_at
      t.string :edit_mode

      t.timestamps
    end
    add_index :event_import_files, :parent_id
  end

  def self.down
    drop_table :event_import_files
  end
end
