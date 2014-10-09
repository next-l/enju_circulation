class ManifestationCheckoutStatTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :manifestation_cehckout_stat, inverse_of: :manifestation_checkout_stat_transitions
end

# == Schema Information
#
# Table name: manifestation_checkout_stat_transitions
#
#  id                             :integer          not null, primary key
#  to_state                       :string(255)
#  metadata                       :text             default("{}")
#  sort_key                       :integer
#  manifestation_checkout_stat_id :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
