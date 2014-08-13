class ReserveStatHasUser < ActiveRecord::Base
  attr_accessible
  attr_accessible :user_reserve_stat_id, :user_id,
    as: :admin
  belongs_to :user_reserve_stat
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :user_reserve_stat_id
  validates_presence_of :user_reserve_stat_id, :user_id

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
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

