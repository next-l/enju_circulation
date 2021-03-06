require 'rails_helper'

describe CheckedItem do
  fixtures :all

  it "should respond to available_for_checkout?" do
    checked_items(:checked_item_00001).available_for_checkout?.should_not be_truthy
  end

  it "should change circulation_status when a missing item is found" do
    basket = Basket.new
    basket.user = users(:admin)
    checked_item = CheckedItem.new
    checked_item.item = items(:item_00024)
    checked_item.basket = basket
    checked_item.save!
    items(:item_00024).circulation_status.name.should eq 'Available On Shelf'
  end
end

# == Schema Information
#
# Table name: checked_items
#
#  id           :bigint           not null, primary key
#  item_id      :bigint           not null
#  basket_id    :bigint           not null
#  librarian_id :bigint
#  due_date     :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
