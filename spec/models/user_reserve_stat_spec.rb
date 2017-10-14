require 'rails_helper'

describe UserReserveStat do
  fixtures :all

  it 'calculates user count' do
    old_message_count = Message.count
    user_reserve_stats(:one).transition_to!(:started).should be_truthy
    Message.count.should eq old_message_count + 1
    Message.order(created_at: :desc).first.subject.should eq '集計が完了しました'
  end

  #it 'should calculate in background' do
  #  UserReserveStatJob.perform_later(user_reserve_stats(:one)).should be_truthy
  #end
end

# == Schema Information
#
# Table name: user_reserve_stats
#
#  id           :integer          not null, primary key
#  start_date   :datetime
#  end_date     :datetime
#  note         :text
#  created_at   :datetime
#  updated_at   :datetime
#  started_at   :datetime
#  completed_at :datetime
#  user_id      :integer
#
