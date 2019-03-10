class ManifestationReserveStatTransition < ActiveRecord::Base

  
  belongs_to :manifestation_reserve_stat, inverse_of: :manifestation_reserve_stat_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: manifestation_reserve_stat_transitions
#
#  id                            :bigint(8)        not null, primary key
#  to_state                      :string
#  metadata                      :jsonb
#  sort_key                      :integer
#  manifestation_reserve_stat_id :uuid
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  most_recent                   :boolean          not null
#
