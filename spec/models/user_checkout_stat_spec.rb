# -*- encoding: utf-8 -*-
require 'spec_helper'

describe UserCheckoutStat do
  fixtures :user_checkout_stats

  it "calculates user count" do
    user_checkout_stats(:one).transition_to!(:started).should be_truthy
  end

  it "should calculate in background" do
    UserCheckoutStatQueue.perform(user_checkout_stats(:one).id).should be_truthy
  end
end

# == Schema Information
#
# Table name: user_checkout_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  state        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  started_at   :datetime
#  completed_at :datetime
#
