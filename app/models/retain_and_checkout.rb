class RetainAndCheckout < ApplicationRecord
  belongs_to :retain
  belongs_to :checkout
end

# == Schema Information
#
# Table name: retain_and_checkouts
#
#  id          :integer          not null, primary key
#  retain_id   :integer          not null
#  checkout_id :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
