require 'rails_helper'

describe Item do
  # pending "add some examples to (or delete) #{__FILE__}"
  fixtures :all

  it "should be rent" do
    items(:item_00001).rent?.should be_truthy
  end

  it "should not be rent" do
    items(:item_00010).rent?.should be_falsy
  end

  it "should be checked out" do
    items(:item_00010).checkout!(users(:admin)).should be_truthy
    items(:item_00010).circulation_status.name.should eq 'On Loan'
  end

  it "should be checked in" do
    items(:item_00001).checkin!.should be_truthy
    items(:item_00001).circulation_status.name.should eq 'Available On Shelf'
  end

  it "should be retained" do
    old_count = MessageRequest.count
    items(:item_00013).retain(users(:librarian1)).should be_truthy
    items(:item_00013).reserves.first.current_state.should eq 'retained'
    MessageRequest.count.should eq old_count + 4
  end

  it "should not be checked out when it is reserved" do
    items(:item_00012).available_for_checkout?.should be_falsy
  end

  it "should not be able to checkout a removed item" do
    Item.for_checkout.include?(items(:item_00023)).should be_falsy
  end

  it "should delete lending policies" do
    item = items(:item_00001)
    item.checkout_type = CheckoutType.find_by(name: 'serial')
    item.save
    item.reload
    item.lending_policies.count.should eq 0
  end
end
