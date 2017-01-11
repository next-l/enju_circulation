class ReserveTransition < ActiveRecord::Base
  #include Statesman::Adapters::ActiveRecordTransition

  belongs_to :reserve, inverse_of: :reserve_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: reserve_transitions
#
#  id          :integer          not null, primary key
#  to_state    :string           not null
#  metadata    :jsonb
#  sort_key    :integer          not null
#  reserve_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  most_recent :boolean
#
