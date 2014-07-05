class ManifestationReserveStatTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :manifestation_reserve_stat, inverse_of: :manifestation_reserve_stat_transitions
  attr_accessible :to_state, :sort_key, :metadata
end