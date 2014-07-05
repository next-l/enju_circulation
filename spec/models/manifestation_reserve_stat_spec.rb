# -*- encoding: utf-8 -*-
require 'spec_helper'

describe ManifestationReserveStat do
  fixtures :manifestation_reserve_stats

  it "calculates manifestation count" do
    manifestation_reserve_stats(:one).transition_to!(:started).should be_truthy
  end

  it "should calculate in background" do
    ManifestationReserveStatQueue.perform(manifestation_reserve_stats(:one).id).should be_truthy
  end
end

# == Schema Information
#
# Table name: manifestation_reserve_stats
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
