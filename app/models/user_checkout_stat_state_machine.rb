class UserCheckoutStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :completed

  transition from: :pending, to: :completed

  before_transition(to: :completed) do |user_checkout_stat|
    user_checkout_stat.calculate_count
  end
end
