# -*- encoding: utf-8 -*-
require 'spec_helper'

describe ManifestationCheckoutStat do
  fixtures :manifestation_checkout_stats

  it "calculates manifestation count" do
    manifestation_checkout_stats(:one).transition_to!(:started).should be_truthy
  end

  it "should calculate in background" do
    ManifestationCheckoutStatQueue.perform(manifestation_checkout_stats(:one).id).should be_truthy
  end
end

# == Schema Information
#
# Table name: manifestation_checkout_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  state        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  started_at   :datetime
#  completed_at :datetime
#

