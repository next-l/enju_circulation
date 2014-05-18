class ReserveTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :reserve, inverse_of: :reserve_transitions
end
