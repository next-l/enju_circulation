require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'withdraw.rb').to_s

class Withdraw < ApplicationRecord
  include EnjuCirculation::EnjuWithdraw
end

# == Schema Information
#
# Table name: withdraws
#
#  id           :integer          not null, primary key
#  basket_id    :integer
#  item_id      :integer
#  librarian_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
