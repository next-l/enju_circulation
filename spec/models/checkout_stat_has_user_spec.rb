require 'rails_helper'

describe CheckoutStatHasUser do
  # pending "add some examples to (or delete) #{__FILE__}"

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
