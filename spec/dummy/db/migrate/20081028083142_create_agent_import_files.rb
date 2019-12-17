class CreateAgentImportFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :agent_import_files do |t|
      t.references :user, foreign_key: true
      t.text :note, comment: '備考'
      t.datetime :executed_at

      t.timestamps
    end
  end
end
