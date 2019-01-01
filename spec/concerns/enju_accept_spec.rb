require 'rails_helper'

class MyAccept < Accept
  include EnjuCirculation::EnjuAccept
end

describe EnjuCirculation::EnjuAccept do
  fixtures :all
  before do
    Checkout.reindex
  end

  it "should successfully accept" do
    accept = MyAccept.new(FactoryBot.attributes_for(:accept))
    expect(accept.item).to be_truthy
    expect(accept.item.circulation_status.name).to eq "In Process"
    accept.save!
    expect(accept.item.circulation_status.name).to eq "Available On Shelf"
    expect(accept.item.use_restriction.name).to eq "Limited Circulation, Normal Loan Period"
  end

  it "should reflect to items list", solr: true do
    3.times do
      FactoryBot.create(:item)
    end
    item_count = Item.count
    inprocess_count = Item.where(circulation_status: CirculationStatus.find_by(name: "In Process")).count
    onshelf_count = Item.where(circulation_status: CirculationStatus.find_by(name: "Available On Shelf")).count
    accept = MyAccept.new(FactoryBot.attributes_for(:accept))
    accept.save!
    expect(Item.where(circulation_status: CirculationStatus.find_by(name: "In Process")).count).to eq inprocess_count
    expect(Item.where(circulation_status: CirculationStatus.find_by(name: "Available On Shelf")).count).to eq onshelf_count + 1
  end
end
