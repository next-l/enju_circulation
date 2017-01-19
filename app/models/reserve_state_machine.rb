class ReserveStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :postponed
  state :requested
  state :retained
  state :canceled
  state :expired
  state :completed

  transition from: :pending, to: [:requested, :retained, :expired]
  transition from: :postponed, to: [:requested, :retained, :canceled, :expired]
  transition from: :retained, to: [:postponed, :canceled, :expired, :completed]
  transition from: :requested, to: [:retained, :canceled, :expired, :completed]

  after_transition(to: :requested) do |reserve|
    reserve.update_attributes({request_status_type: RequestStatusType.find_by(name: 'In Process')})
  end

  before_transition(to: :retained) do |reserve|
    Retain.create!(reserve: reserve, item: reserve.item)
  end

  after_transition(to: :retained) do |reserve|
    # TODO: 「取り置き中」の状態を正しく表す
    reserve.update_attributes({request_status_type: RequestStatusType.find_by(name: 'In Process')})
    if reserve.retain.item #and reserve.next_reservation
      Reserve.transaction do
        reserve.item.reserves.not_in_state(:canceled, :expired, :completed).map{|r|
          if r != reserve
            r.transition_to!(:postponed)
            r.item = nil
            r.save!
          end
        }
      end
    end
  end

  after_transition(to: :canceled) do |reserve|
    Reserve.transaction do
      reserve.update_attributes({request_status_type: RequestStatusType.find_by(name: 'Cannot Fulfill Request')})
      next_reserve = reserve.next_reservation
      if next_reserve
        next_reserve.item = reserve.item
        reserve.item = nil
        reserve.save!
        next_reserve.transition_to!(:retained)
      end
    end
  end

  after_transition(to: :expired) do |reserve|
    Reserve.transaction do
      reserve.update_attributes({request_status_type: RequestStatusType.find_by(name: 'Expired')})
      next_reserve = reserve.next_reservation
      if next_reserve
        next_reserve.item = reserve.item
        next_reserve.transition_to!(:retained)
        reserve.item = nil
        reserve.save!
      end
    end
    Rails.logger.info "#{Time.zone.now} reserve_id #{reserve.id} expired!"
  end

  after_transition(to: :postponed) do |reserve|
    reserve.update_attributes(item_id: nil, force_retaining: "1")
  end

  after_transition(to: :completed) do |reserve|
    reserve.update_attributes(
      request_status_type: RequestStatusType.find_by(name: 'Available For Pickup')
    )
  end

  after_transition(to: :requested) do |reserve|
    reserve.send_message
  end

  after_transition(to: :expired) do |reserve|
    reserve.send_message
  end

  after_transition(to: :postponed) do |reserve|
    reserve.send_message
  end

  after_transition(to: :canceled) do |reserve|
    reserve.send_message
  end

  after_transition(to: :retained) do |reserve|
    reserve.send_message
  end
end
