class ManifestationReserveStatStateMachine
  include Statesman::Machine
  state :pending, initial: true
  state :completed

  transition from: :pending, to: :completed

  before_transition(to: :started) do |manifestation_reserve_stat|
    manifestation_reserve_stat.calculate_count!
  end
end
