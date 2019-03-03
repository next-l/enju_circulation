require 'rails_helper'
  
describe ResourceImportFile do
  fixtures :all
  
  describe "when its mode is 'destroy'" do
    it "should remove items", vcr: true do
      old_count = Item.count
      file = ResourceImportFile.create!(
        user: users(:admin),
        edit_mode: 'destroy'
      )
      file.resource_import.attach(io: File.new("#{Rails.root}/../../examples/item_delete_file.tsv"), filename: 'attachment.txt')
      file.remove
      Item.count.should eq old_count - 1
    end
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                          :uuid             not null, primary key
#  user_id                     :bigint(8)
#  note                        :text
#  executed_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  edit_mode                   :string
#  resource_import_fingerprint :string
#  error_message               :text
#  user_encoding               :string
#  default_shelf_id            :uuid
#
