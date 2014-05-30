class ItemTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :item, inverse_of: :item_transitions
end
