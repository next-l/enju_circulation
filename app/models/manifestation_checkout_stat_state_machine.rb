class ManifestationCheckoutStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :completed

  state :started
  state :completed

  transition from: :pending, to: :started
  transition from: :started, to: :completed

  before_transition(to: :started) do |manifestation_checkout_stat|
    manifestation_checkout_stat.calculate_count!
  end
end
