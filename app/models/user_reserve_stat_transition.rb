class UserReserveStatTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :user_reserve_stat, inverse_of: :user_reserve_stat_transitions
end
