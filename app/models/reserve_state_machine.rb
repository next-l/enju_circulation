class ReserveStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :requested
  state :canceled
  state :expired
  state :completed

  transition from: :pending, to: [:requested, :expired]
  transition from: :requested, to: [:canceled, :expired, :completed]

  after_transition(to: :requested) do |reserve|
    reserve.update_attributes({request_status_type: RequestStatusType.find_by(name: 'In Process')})
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

  after_transition(to: :canceled) do |reserve|
    reserve.send_message
  end
end
