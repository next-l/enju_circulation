class ManifestationCheckoutStatTransition < ActiveRecord::Base
  #include Statesman::Adapters::ActiveRecordTransition

  belongs_to :manifestation_cehckout_stat, inverse_of: :manifestation_checkout_stat_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: manifestation_checkout_stat_transitions
#
#  id                             :integer          not null, primary key
#  to_state                       :string
#  metadata                       :text             default("{}")
#  sort_key                       :integer
#  manifestation_checkout_stat_id :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#  most_recent                    :boolean
#
