class ItemTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :item, inverse_of: :item_transitions
end

# == Schema Information
#
# Table name: item_transitions
#
#  id         :integer          not null, primary key
#  to_state   :string(255)
#  metadata   :text             default("{}")
#  sort_key   :integer
#  item_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
