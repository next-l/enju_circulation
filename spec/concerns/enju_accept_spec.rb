require 'rails_helper'

describe EnjuCirculation::EnjuAccept do
  fixtures :all

  it "should successfully accept" do
    accept = Accept.new(FactoryBot.attributes_for(:accept))
    accept.item = FactoryBot.create(:item)
    accept.save!
    expect(accept.item.circulation_status.name).to eq "Available On Shelf"
    expect(accept.item.use_restriction.name).to eq "Limited Circulation, Normal Loan Period"
  end

  it "should reflect to items list", solr: true do
    Item.reindex

    3.times do
      FactoryBot.create(:item, circulation_status: CirculationStatus.find_by(name: 'In Process'))
    end

    result = Item.search.build { facet :circulation_status }.execute
    inprocess_count = result.facet(:circulation_status).rows.find{|e| e.value == "In Process" }.count
    onshelf_count = result.facet(:circulation_status).rows.find{|e| e.value == "Available On Shelf" }.try(:count) || 0

    accept = Accept.new(FactoryBot.attributes_for(:accept))
    accept.item = FactoryBot.create(:item)
    accept.save!
    result = Item.search.build { facet :circulation_status }.execute
    expect(result.facet(:circulation_status).rows.find{|e| e.value == "In Process" }.count).to eq inprocess_count
    expect(result.facet(:circulation_status).rows.find{|e| e.value == "Available On Shelf" }.try(:count)).to eq onshelf_count + 1
  end
end
