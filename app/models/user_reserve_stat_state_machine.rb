class UserReserveStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :started
  state :completed
  state :failed

  transition from: :pending, to: [:started, :failed]
  transition from: :started, to: [:completed, :failed]

  after_transition(to: :started) do |user_reserve_stat|
    user_reserve_stat.update_column(:started_at, Time.zone.now)
    user_reserve_stat.calculate_count!
  end

  after_transition(to: :completed) do |user_reserve_stat|
    user_reserve_stat.update_column(:completed_at, Time.zone.now)
  end
end
