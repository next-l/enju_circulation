require 'rails_helper'

describe Manifestation, solr: true do
  fixtures :all

  it "should be reserved" do
    manifestations(:manifestation_00007).is_reserved_by?(users(:admin)).should be_truthy
  end

  it "should not be reserved" do
    manifestations(:manifestation_00007).is_reserved_by?(users(:user1)).should be_falsy
  end

  it "should not be reserved it it has no item" do
    manifestations(:manifestation_00008).is_reservable_by?(users(:admin)).should be_falsy
  end

  it "should not export use_restriction for Guest" do
    manifestation = FactoryBot.create(:manifestation)
    use_restriction = UseRestriction.find(1)
    item = FactoryBot.create(:item, manifestation: manifestation, use_restriction: use_restriction)
    lines = Manifestation.export(format: :txt, role: "Guest")
    csv = CSV.parse(lines, headers: true, col_sep: "\t")
    expect(csv["use_restriction"].compact).to be_empty

    lines = Manifestation.export(format: :txt, role: "Administrator")
    csv = CSV.parse(lines, headers: true, col_sep: "\t")
    expect(csv["use_restriction"].compact).not_to be_empty
  end

  it "should respond to is_checked_out_by?" do
    manifestations(:manifestation_00001).is_checked_out_by?(users(:admin)).should be_truthy
    manifestations(:manifestation_00001).is_checked_out_by?(users(:librarian2)).should be_falsy
  end
end
