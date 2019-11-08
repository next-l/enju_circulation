class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages, force: true do |t|
      t.datetime :read_at
      t.references :sender, foreign_key: {to_table: :users}
      t.references :receiver, foreign_key: {to_table: :users}
      t.string   :subject, null: false
      t.text     :body
      t.references :message_request
      t.references :parent, foreign_key: {to_table: :messages}

      t.timestamps
    end
  end
end
