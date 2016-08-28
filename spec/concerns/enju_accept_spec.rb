require 'rails_helper'

class MyAccept < Accept
  include EnjuCirculation::EnjuAccept
end

describe EnjuCirculation::EnjuAccept do
  it "should successfully accept" do
    accept = MyAccept.new(FactoryGirl.attributes_for(:accept))
    expect(accept.item).to be_truthy
    expect(accept.item.circulation_status.name).to eq "In Process"
    accept.save!
    expect(accept.item.circulation_status.name).to eq "Available On Shelf"
    expect(accept.item.use_restriction.name).to eq "Limited Circulation, Normal Loan Period"
  end
  it "should reflect to items list", solr: true do
    FactoryGirl.create(:item)
    FactoryGirl.create(:item)
    FactoryGirl.create(:item)
    result = Item.search.build { facet :circulation_status }.execute
    inprocess_count = result.facet(:circulation_status).rows.find{|e| e.value == "In Process" }.count
    onshelf_count = result.facet(:circulation_status).rows.find{|e| e.value == "Available On Shelf" }.try(:count) || 0
    accept = MyAccept.new(FactoryGirl.attributes_for(:accept))
    accept.save!
    result = Item.search.build { facet :circulation_status }.execute
    expect(result.facet(:circulation_status).rows.find{|e| e.value == "In Process" }.count).to eq inprocess_count
    expect(result.facet(:circulation_status).rows.find{|e| e.value == "Available On Shelf" }.try(:count)).to eq onshelf_count + 1
  end
end
