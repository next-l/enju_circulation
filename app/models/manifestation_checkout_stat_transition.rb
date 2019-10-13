class ManifestationCheckoutStatTransition < ApplicationRecord

  
  belongs_to :manifestation_checkout_stat, inverse_of: :manifestation_checkout_stat_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: manifestation_checkout_stat_transitions
#
#  id                             :bigint           not null, primary key
#  to_state                       :string
#  metadata                       :jsonb
#  sort_key                       :integer
#  manifestation_checkout_stat_id :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  most_recent                    :boolean          not null
#
