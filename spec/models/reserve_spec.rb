require 'rails_helper'

describe Reserve do
  fixtures :all

  it 'should have next reservation' do
    reserves(:reserve_00014).next_reservation.should be_truthy
  end

  it 'should notify a next reservation' do
    old_count = Message.count
    reserve = reserves(:reserve_00014)
    item = reserve.next_reservation.item
    reserve.transition_to!(:expired)
    reserve.current_state.should eq 'expired'
    item.should eq reserve.item
    Message.count.should eq old_count + 4
  end

  it 'should expire reservation' do
    reserves(:reserve_00001).transition_to!(:expired)
    reserves(:reserve_00001).request_status_type.name.should eq 'Expired'
  end

  it 'should cancel reservation' do
    reserves(:reserve_00001).transition_to!(:canceled)
    reserves(:reserve_00001).state_machine.in_state?(:canceled).should be_truthy
    reserves(:reserve_00001).request_status_type.name.should eq 'Cannot Fulfill Request'
  end

  it 'should not have next reservation' do
    reserves(:reserve_00002).next_reservation.should be_nil
  end

  it 'should send accepted message' do
    old_admin_count = User.find_by(username: 'enjuadmin').received_messages.count
    old_user_count = reserves(:reserve_00002).user.received_messages.count
    reserves(:reserve_00002).send_message.should be_truthy
    # 予約者と図書館の両方に送られる
    User.find_by(username: 'enjuadmin').received_messages.count.should eq old_admin_count + 1
    reserves(:reserve_00002).user.received_messages.count.should eq old_user_count + 1
  end

  it 'should send expired message' do
    old_count = MessageRequest.count
    reserves(:reserve_00008).send_message.should be_truthy
    MessageRequest.count.should eq old_count + 2
  end

  it 'should send message to library' do
    Reserve.send_message_to_library('expired', manifestations: Reserve.not_sent_expiration_notice_to_library.collect(&:manifestation)).should be_truthy
  end

  it 'should have reservations that will be expired' do
    reserve = FactoryGirl.create(:reserve)
    reserve.state_machine.transition_to!(:requested)
    item = FactoryGirl.create(:item, manifestation_id: reserve.manifestation.id)
    item.retain!(reserve.user)
    reserve.reload
    reserve.save!
    ReserveAndExpiringDate.create(reserve: reserve, expire_on: Date.yesterday)
    expect(Reserve.will_expire_on(Time.zone.now).in_state(:retained)).to include reserve
  end

  it 'should have completed reservation' do
    reserve = FactoryGirl.create(:reserve)
    reserve.state_machine.transition_to!(:requested)
    item = FactoryGirl.create(:item, manifestation_id: reserve.manifestation.id)
    item.checkout!(reserve.user)
    expect(Reserve.in_state(:completed)).to include reserve
  end

  it 'should expire all reservations' do
    assert Reserve.expire.should be_truthy
  end

  it 'should send accepted notification' do
    assert Reserve.expire.should be_truthy
  end

  it "should nullify the first reservation's item_id if the second reservation is retained" do
    reservation = reserves(:reserve_00015)
    old_reservation = reserves(:reserve_00014)
    old_count = MessageRequest.count

    reservation.item = old_reservation.item
    expect(reservation).not_to be_retained
    reservation.transition_to!(:retained)
    old_reservation.reload
    #old_reservation.retain.should be_truthy
    reservation.state_machine.in_state?(:retained).should be_truthy
    #    old_reservation.retained_at.should be_nil
    #    old_reservation.postponed_at.should be_truthy
    old_reservation.current_state.should eq 'postponed'
    MessageRequest.count.should eq old_count + 4
    reservation.item.retained?.should be_truthy
  end

  it 'should not be valid if item_identifier is invalid' do
    reservation = reserves(:reserve_00014)
    reservation.item_identifier = 'invalid'
    reservation.save
    assert reservation.valid?.should eq false
  end

  it 'should be treated as Waiting' do
    reserve = FactoryGirl.create(:reserve)
    expect(Reserve.waiting).to include reserve
    reserve_expired = FactoryGirl.create(:reserve)
    reserve.transition_to!(:expired)
    expect(Reserve.waiting).to include reserve_expired
  end

  it 'should not retain against reserves with already retained' do
    reserve = FactoryGirl.create(:reserve)
    reserve.transition_to!(:requested)
    manifestation = reserve.manifestation
    item = FactoryGirl.create(:item, manifestation_id: manifestation.id)
    expect { item.retain!(reserve.user) }.not_to raise_error
    expect(reserve.retained?).to be true
    expect(item.retained?).to be true
    item = FactoryGirl.create(:item, manifestation_id: manifestation.id)
    expect { item.retain!(reserve.user) }.not_to raise_error
    expect(reserve.retained?).to be true
    expect(item.retained?).to be false
  end
end

# == Schema Information
#
# Table name: reserves
#
#  id                           :uuid             not null, primary key
#  user_id                      :integer          not null
#  manifestation_id             :uuid             not null
#  item_id                      :uuid
#  request_status_type_id       :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  expiration_notice_to_patron  :boolean          default(FALSE)
#  expiration_notice_to_library :boolean          default(FALSE)
#  pickup_location_id           :uuid             not null
#  lock_version                 :integer          default(0), not null
#
