require 'rails_helper'

describe "checked_items/new" do
  fixtures :all

  it "renders new checkout form" do
    profile = FactoryGirl.create(:profile, user_number: "foo")
    user = FactoryGirl.create(:user, profile: profile, username: "bar")
    basket = FactoryGirl.create(:basket, user: user)
    assign(:basket, basket)
    assign(:checked_items, basket.checked_items)
    render
    expect(rendered).to match /bar/
    expect(rendered).to match /foo/
  end
end
