class Retain < ApplicationRecord
  belongs_to :reserve
  belongs_to :item
end

# == Schema Information
#
# Table name: retains
#
#  id         :bigint           not null, primary key
#  reserve_id :bigint           not null
#  item_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
