require 'rails_helper'

RSpec.describe Retain, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
