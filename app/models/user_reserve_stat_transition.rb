class UserReserveStatTransition < ActiveRecord::Base

  
  belongs_to :user_reserve_stat, inverse_of: :user_reserve_stat_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: user_reserve_stat_transitions
#
#  id                   :bigint(8)        not null, primary key
#  to_state             :string
#  metadata             :jsonb
#  sort_key             :integer
#  user_reserve_stat_id :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  most_recent          :boolean          not null
#
