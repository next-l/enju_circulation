class ReserveTransition < ActiveRecord::Base

  
  belongs_to :reserve, inverse_of: :reserve_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: reserve_transitions
#
#  id          :bigint           not null, primary key
#  to_state    :string
#  metadata    :jsonb
#  sort_key    :integer
#  reserve_id  :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  most_recent :boolean          not null
#
