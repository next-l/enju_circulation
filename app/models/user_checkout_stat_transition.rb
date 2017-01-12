class UserCheckoutStatTransition < ActiveRecord::Base
  #include Statesman::Adapters::ActiveRecordTransition

  belongs_to :user_checkout_stat, inverse_of: :user_checkout_stat_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: user_checkout_stat_transitions
#
#  id                    :integer          not null, primary key
#  to_state              :string           not null
#  metadata              :jsonb
#  sort_key              :integer          not null
#  user_checkout_stat_id :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  most_recent           :boolean
#
