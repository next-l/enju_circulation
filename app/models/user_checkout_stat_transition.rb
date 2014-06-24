class UserCheckoutStatTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :user_checkout_stat, inverse_of: :user_checkout_stat_transitions
  attr_accessible :to_state, :sort_key, :metadata
end
