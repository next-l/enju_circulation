require 'rails_helper'
  
describe ResourceExportFile do
  fixtures :all
  
  it "should export total_checkouts" do
    item1 = FactoryBot.create(:item)
    item2 = FactoryBot.create(:item)
    checkout = FactoryBot.create(:checkout, item: item2)
    export_file = ResourceExportFile.new
    export_file.user = users(:admin)
    export_file.save!
    export_file.export!
    file = export_file.resource_export
    expect(file).to be_truthy
    csv = CSV.open(file.path, {headers: true, col_sep: "\t"})
    csv.each do |row|
      expect(row).to have_key "total_checkouts"
      case row["item_id"].to_i
      when item1.id
        expect(row["total_checkouts"].to_i).to eq 0
      when item2.id
        expect(row["total_checkouts"].to_i).to eq 1
      end
    end
  end
end
