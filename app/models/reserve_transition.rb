class ReserveTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :reserve, inverse_of: :reserve_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: reserve_transitions
#
#  id          :integer          not null, primary key
#  to_state    :string
#  metadata    :text             default({})
#  sort_key    :integer
#  reserve_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  most_recent :boolean          not null
#
