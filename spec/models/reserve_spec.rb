require 'rails_helper'

describe Reserve do
  fixtures :all

  it 'should have next reservation' do
    reserves(:reserve_00014).next_reservation.should be_truthy
  end

  it 'should notify a next reservation' do
    old_count = Message.count
    reserve = reserves(:reserve_00015)
    reserve.transition_to!(:expired)
    reserve.current_state.should eq 'expired'
    Message.count.should eq old_count + 2
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
    reserve = FactoryBot.create(:reserve)
    reserve.state_machine.transition_to!(:requested)
    item = FactoryBot.create(:item, manifestation_id: reserve.manifestation.id)
    item.retain!(reserve.user)
    reserve.reload
    reserve.save!
    ReserveAndExpiringDate.create(reserve: reserve, expire_on: Date.yesterday)
    expect(Reserve.will_expire_on(Time.zone.now).first.retain).to be_truthy
  end

  it 'should have completed reservation' do
    reserve = FactoryBot.create(:reserve)
    reserve.state_machine.transition_to!(:requested)
    item = FactoryBot.create(:item, manifestation_id: reserve.manifestation.id)
    basket = FactoryBot.create(:basket, user: reserve.user)
    basket.checked_items.create(item: item)
    basket.basket_checkout(basket.user)
    expect(RetainAndCheckout.order(created_at: :desc).first).to be_truthy
  end

  it 'should expire all reservations' do
    assert Reserve.expire.should be_truthy
  end

  it 'should send accepted notification' do
    assert Reserve.expire.should be_truthy
  end

  it 'should not be valid if item_identifier is invalid' do
    reservation = reserves(:reserve_00014)
    reservation.item_identifier = 'invalid'
    reservation.save
    assert reservation.valid?.should eq false
  end

  it 'should be treated as Waiting' do
    reserve = FactoryBot.create(:reserve)
    expect(Reserve.waiting).to include reserve
    reserve_expired = FactoryBot.create(:reserve)
    reserve.transition_to!(:expired)
    expect(Reserve.waiting).to include reserve_expired
  end

  it 'should not retain against reserves with already retained' do
    reserve = FactoryBot.create(:reserve)
    reserve.transition_to!(:requested)
    manifestation = reserve.manifestation
    item = FactoryBot.create(:item, manifestation_id: manifestation.id)
    expect { item.retain!(reserve.user) }.not_to raise_error
    reserve.reload
    item.reload
    expect(reserve.retain).to be_truthy
    expect(item.retained?).to be true
    item = FactoryBot.create(:item, manifestation_id: manifestation.id)
    expect { item.retain!(reserve.user) }.not_to raise_error
    reserve.reload
    item.reload
    expect(reserve.retain).to be_truthy
    expect(item.retained?).to be true
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
#  expiration_notice_to_patron  :boolean          default(FALSE), not null
#  expiration_notice_to_library :boolean          default(FALSE), not null
#  pickup_location_id           :uuid             not null
#  lock_version                 :integer          default(0), not null
#
