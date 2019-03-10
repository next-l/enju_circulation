class CheckoutStatHasUser < ActiveRecord::Base
  # attr_accessible :user_checkout_stat_id, :user_id,
  #  as: :admin
  belongs_to :user_checkout_stat
  belongs_to :user

  validates :user_id, uniqueness: { scope: :user_checkout_stat_id }
  validates :user_checkout_stat_id, :user_id, presence: true

  paginates_per 10
end

# == Schema Information
#
# Table name: checkout_stat_has_users
#
#  id                    :bigint(8)        not null, primary key
#  user_checkout_stat_id :uuid             not null
#  user_id               :bigint(8)        not null
#  checkouts_count       :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
