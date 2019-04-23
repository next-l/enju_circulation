require 'rails_helper'

describe Checkin do
  fixtures :all

  before(:each) do
    @basket = Basket.new
    @basket.user = users(:librarian1)
    @basket.save
  end

  it "should save checkout history if save_checkout_history is true" do
    user = users(:user1)
    checkouts_count = user.checkouts.count
    checkin = Checkin.new
    checkin.item_identifier = user.checkouts.not_returned.order(created_at: :desc).first.item.item_identifier
    checkin.basket = @basket
    checkin.librarian = users(:librarian1)
    checkin.save!
    checkin.item_checkin(user)
    user.checkouts.count.should eq checkouts_count
  end

  it "should not save checkout history if save_checkout_history is false" do
    user = users(:librarian1)
    checkouts_count = user.checkouts.count
    checkin = Checkin.new
    checkin.checkout = user.checkouts.not_returned.order(created_at: :desc).first
    checkin.basket = @basket
    checkin.librarian = users(:librarian1)
    checkin.save!
    checkin.item_checkin(user)
    user.checkouts.count.should eq checkouts_count - 1
  end
end

# == Schema Information
#
# Table name: checkins
#
#  id           :bigint(8)        not null, primary key
#  librarian_id :bigint(8)
#  basket_id    :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lock_version :integer          default(0), not null
#  checkout_id  :bigint(8)        not null
#
