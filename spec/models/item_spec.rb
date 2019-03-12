require 'rails_helper'

describe Item do
  # pending "add some examples to (or delete) #{__FILE__}"
  fixtures :all

  it "should be rent" do
    items(:item_00002).rent?.should be_truthy
  end

  it "should not be rent" do
    items(:item_00018).rent?.should be_falsy
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

  it "should have library_url" do
    items(:item_00001).library_url.should eq "#{LibraryGroup.site_config.url}libraries/web"
  end

  it "should not be able to checkout a removed item" do
    Item.for_checkout.include?(items(:item_00023)).should be_falsy
  end

  it "should update lending policy" do
    item = items(:item_00001)
    item.lending_rule(users(:user1)).checkout_period.should eq 1
    item.checkout_type = CheckoutType.find_by(name: 'serial')
    item.save
    item.reload
    item.lending_rule(users(:user1)).checkout_period.should eq 10
  end

  it "should not create item without manifestation_id" do
    item = items(:item_00001)
    item.manifestation_id = nil
    item.valid?.should be_falsy
  end
end

# == Schema Information
#
# Table name: items
#
#  id                      :uuid             not null, primary key
#  call_number             :string
#  item_identifier         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  shelf_id                :uuid
#  include_supplements     :boolean          default(FALSE), not null
#  note                    :text
#  url                     :string
#  price                   :integer
#  lock_version            :integer          default(0), not null
#  required_role_id        :integer          default(1), not null
#  acquired_at             :datetime
#  bookstore_id            :bigint(8)
#  budget_type_id          :integer
#  circulation_status_id   :bigint(8)        default(5), not null
#  checkout_type_id        :bigint(8)        default(1), not null
#  binding_item_identifier :string
#  binding_call_number     :string
#  binded_at               :datetime
#  manifestation_id        :uuid             not null
#
