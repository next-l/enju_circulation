class ReserveAndExpiringDate < ApplicationRecord
  belongs_to :reserve
end

# == Schema Information
#
# Table name: reserve_and_expiring_dates
#
#  id         :integer          not null, primary key
#  reserve_id :uuid             not null
#  expire_on  :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
