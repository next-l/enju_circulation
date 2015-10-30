# -*- encoding: utf-8 -*-
require 'spec_helper'

describe User do
  it "should get user's checkouts" do
    user = FactoryGirl.create(:user)
    checkout1 = FactoryGirl.create(:checkout, user: user)
    checkout2 = FactoryGirl.create(:checkout, user: user)
    expect(user.checkouts).not_to be_empty
    expect(user.checkouts.first).to eq checkout2
  end
end
