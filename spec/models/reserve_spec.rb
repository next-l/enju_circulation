# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Reserve do
  fixtures :all

  it "should have next reservation" do
    reserves(:reserve_00014).next_reservation.should be_true
  end

  it "should notify a next reservation" do
    old_count = Message.count
    reserve = reserves(:reserve_00014)
    item = reserve.next_reservation.item
    reserve.sm_expire!
    reserve.state.should eq 'expired'
    item.should eq reserve.item
    Message.count.should eq old_count + 2
  end

  it "should expire reservation" do
    reserves(:reserve_00001).sm_expire!
    reserves(:reserve_00001).request_status_type.name.should eq 'Expired'
  end

  it "should cancel reservation" do
    reserves(:reserve_00001).sm_cancel!
    reserves(:reserve_00001).canceled_at.should be_true
    reserves(:reserve_00001).request_status_type.name.should eq 'Cannot Fulfill Request'
  end

  it "should not have next reservation" do
    reserves(:reserve_00002).next_reservation.should be_nil
  end

  it "should send accepted message" do
    old_admin_count = User.find('admin').received_messages.count
    old_user_count = reserves(:reserve_00002).user.received_messages.count
    reserves(:reserve_00002).send_message.should be_true
    # 予約者と図書館の両方に送られる
    User.find('admin').received_messages.count.should eq old_admin_count + 1
    reserves(:reserve_00002).user.received_messages.count.should eq old_user_count + 1
  end

  it "should send expired message" do
    old_count = MessageRequest.count
    reserves(:reserve_00006).send_message.should be_true
    MessageRequest.count.should eq old_count + 2
  end

  it "should send message to library" do
    Reserve.send_message_to_library('expired', :manifestations => Reserve.not_sent_expiration_notice_to_library.collect(&:manifestation)).should be_true
  end

  it "should have reservations that will be expired" do
    Reserve.will_expire_retained(Time.zone.now).size.should eq 1
  end

  it "should have completed reservation" do
    Reserve.completed.size.should eq 1
  end

  it "should expire all reservations" do
    assert Reserve.expire.should be_true
  end

  it "should send accepted notification" do
    assert Reserve.expire.should be_true
  end

  it "should nullify the first reservation's item_id if the second reservation is retained" do
    reservation = reserves(:reserve_00015)
    old_reservation = reserves(:reserve_00014)
    old_count = MessageRequest.count

    reservation.item = old_reservation.item
    reservation.sm_retain!
    old_reservation.reload
    assert old_reservation.item.should be_nil
    assert reservation.retained_at.should be_true
    assert old_reservation.retained_at.should be_nil
    assert old_reservation.postponed_at.should be_true
    assert old_reservation.state.should eq 'postponed'
    assert MessageRequest.count.should eq old_count + 4
  end

  it "should not be valid if item_identifier is invalid" do
    reservation = reserves(:reserve_00014)
    reservation.item_identifier = 'invalid'
    reservation.save
    assert reservation.valid?.should eq false
  end

  it "should be valid if the reservation is completed and its item is destroyed" do
    reservation = reserves(:reserve_00010)
    reservation.item.destroy
    reservation.reload
    assert reservation.should be_valid
  end
end

# == Schema Information
#
# Table name: reserves
#
#  id                           :integer          not null, primary key
#  user_id                      :integer          not null
#  manifestation_id             :integer          not null
#  item_id                      :integer
#  request_status_type_id       :integer          not null
#  checked_out_at               :datetime
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  canceled_at                  :datetime
#  expired_at                   :datetime
#  deleted_at                   :datetime
#  state                        :string(255)
#  expiration_notice_to_patron  :boolean          default(FALSE)
#  expiration_notice_to_library :boolean          default(FALSE)
#  retained_at                  :datetime
#  postponed_at                 :datetime
#  lock_version                 :integer          default(0), not null
#

