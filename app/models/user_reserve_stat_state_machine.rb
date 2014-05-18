class UserReserveStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :completed

  transition from: :pending, to: :completed

  before_transition(to: :completed) do |user_reserve_stat|
    user_reserve_stat.calculate_count
  end
end
