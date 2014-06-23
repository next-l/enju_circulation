class ManifestationCheckoutStatTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :manifestation_cehckout_stat, inverse_of: :manifestation_checkout_stat_transitions
end
