require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'withdraw.rb').to_s

class Withdraw < ApplicationRecord
  include EnjuCirculation::EnjuWithdraw
end

# == Schema Information
#
# Table name: withdraws
#
#  id           :bigint           not null, primary key
#  basket_id    :bigint
#  item_id      :bigint
#  librarian_id :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
