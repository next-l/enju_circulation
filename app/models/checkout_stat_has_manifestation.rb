class CheckoutStatHasManifestation < ApplicationRecord
  # attr_accessible :manifestation_checkout_stat_id, :manifestation_id,
  #  as: :admin
  belongs_to :manifestation_checkout_stat
  belongs_to :manifestation

  validates :manifestation_id, uniqueness: { scope: :manifestation_checkout_stat_id }
  validates :manifestation_checkout_stat_id, :manifestation_id, presence: true

  paginates_per 10
end

# == Schema Information
#
# Table name: checkout_stat_has_manifestations
#
#  id                             :bigint           not null, primary key
#  manifestation_checkout_stat_id :bigint           not null
#  manifestation_id               :bigint           not null
#  checkouts_count                :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
