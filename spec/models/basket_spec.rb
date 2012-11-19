# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Basket do
  fixtures :all

  it "should not create basket when user is not active" do
    Basket.create(:user => users(:user4)).id.should be_nil
  end

  it "should not check out items that are already checked out" do
    items(:item_00021).checkouts.count.should eq 0
    basket_1 = Basket.new
    basket_1.user = users(:admin)
    basket_1.save
    checked_item_1 = basket_1.checked_items.new
    checked_item_1.item = items(:item_00011)
    checked_item_1.save
    basket_2 = Basket.new
    basket_2.user = users(:user1)
    basket_2.save
    checked_item_2 = basket_2.checked_items.new
    checked_item_2.item = items(:item_00011)
    checked_item_2.save
    basket_1.basket_checkout(users(:librarian1))
    lambda{basket_2.basket_checkout(users(:librarian1))}.should raise_exception ActiveRecord::RecordInvalid
    items(:item_00011).checkouts.first.user.should eq users(:admin)
  end
end

# == Schema Information
#
# Table name: baskets
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  note         :text
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

