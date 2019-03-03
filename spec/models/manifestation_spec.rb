require 'rails_helper'

describe Manifestation, solr: true do
  fixtures :all
  before do
    Manifestation.reindex
  end

  it "should be reserved" do
    manifestations(:manifestation_00007).is_reserved_by?(users(:admin)).should be_truthy
  end

  it "should not be reserved" do
    manifestations(:manifestation_00007).is_reserved_by?(users(:user1)).should be_falsy
  end

  it "should not be reserved it it has no item" do
    manifestations(:manifestation_00008).is_reservable_by?(users(:admin)).should be_falsy
  end
end
