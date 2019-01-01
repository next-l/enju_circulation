class ReserveStatHasUser < ActiveRecord::Base
  # attr_accessible
  # attr_accessible :user_reserve_stat_id, :user_id,
  #  as: :admin
  belongs_to :user_reserve_stat
  belongs_to :user

  validates :user_id, uniqueness: { scope: :user_reserve_stat_id }
  validates :user_reserve_stat_id, :user_id, presence: true

  paginates_per 10
end

# == Schema Information
#
# Table name: reserve_stat_has_users
#
#  id                   :integer          not null, primary key
#  user_reserve_stat_id :integer          not null
#  user_id              :integer          not null
#  reserves_count       :integer
#  created_at           :datetime
#  updated_at           :datetime
#
