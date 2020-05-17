require 'rails_helper'
  
describe ResourceImportFile do
  fixtures :all
  
  describe "when its mode is 'create'" do
    it "should import use_restriction and circulation_status" do
      file = ResourceImportFile.new(
        user: users(:admin),
        default_shelf_id: 3,
        edit_mode: 'create'
      )
      file.attachment.attach(io: File.new("#{Rails.root}/../../examples/resource_import.tsv"), filename: 'attachment.txt')
      file.save
      result = file.import_start
      item_10103 = Item.find_by(item_identifier: '10103')
      expect(item_10103.use_restriction.name).to eq 'In Library Use Only'
      expect(item_10103.circulation_status.name).to eq 'Not Available'
      expect(item_10103.checkout_type.name).to eq 'serial'
      item_00001 = Item.find_by(item_identifier: '00001')
      expect(item_00001.use_restriction.name).to eq 'Supervision Required'
      expect(item_00001.circulation_status.name).to eq 'Available On Shelf'
      expect(item_00001.checkout_type.name).to eq 'book'
      expect(result[:circulation_imported]).to eq 1
      expect(result[:circulation_skipped]).to eq 1
    end
  end

  describe "when its mode is 'update'" do
    it "should import circulation status" do
      file = ResourceImportFile.new(
        user: users(:admin),
        edit_mode: 'update'
      )
      file.attachment.attach(io: File.new("#{Rails.root}/../../examples/resource_update.tsv"), filename: 'attachment.txt')
      file.save
      result = file.import_start
      expect(result[:manifestation_updated]).to eq 3
      expect(file.error_message).to be_nil
      item_00001 = Item.find_by(item_identifier: '00001')
      expect(item_00001.use_restriction.name).to eq 'In Library Use Only'
      expect(item_00001.circulation_status.name).to eq 'Not Available'
      expect(item_00001.checkout_type.name).to eq 'book'
      item_00002 = Item.find_by(item_identifier: '00002')
      expect(item_00002.use_restriction.name).to eq 'In Library Use Only'
      expect(item_00002.circulation_status.name).to eq 'Available On Shelf'
      expect(item_00002.checkout_type.name).to eq 'book'
      expect(result[:circulation_imported]).to eq 2
      expect(result[:circulation_skipped]).to eq 1
    end
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                          :bigint           not null, primary key
#  user_id                     :bigint
#  note                        :text
#  executed_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  edit_mode                   :string
#  resource_import_fingerprint :string
#  error_message               :text
#  user_encoding               :string
#  default_shelf_id            :integer
#
