class Demand < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :message
end

# == Schema Information
#
# Table name: demands
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  item_id    :uuid
#  message_id :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
