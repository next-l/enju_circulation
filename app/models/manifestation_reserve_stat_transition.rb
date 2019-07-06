class ManifestationReserveStatTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :manifestation_reserve_stat, inverse_of: :manifestation_reserve_stat_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: manifestation_reserve_stat_transitions
#
#  id                            :integer          not null, primary key
#  to_state                      :string
#  metadata                      :text             default({})
#  sort_key                      :integer
#  manifestation_reserve_stat_id :integer
#  created_at                    :datetime
#  updated_at                    :datetime
#  most_recent                   :boolean          not null
#
