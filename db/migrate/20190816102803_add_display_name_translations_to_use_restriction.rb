class AddDisplayNameTranslationsToUseRestriction < ActiveRecord::Migration[5.2]
  def change
    add_column :use_restrictions, :display_name_translations, :jsonb, default: {}, null: false
  end
end
