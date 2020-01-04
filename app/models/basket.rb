require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'basket.rb').to_s

class Basket < ApplicationRecord
  include EnjuCirculation::EnjuBasket
end

# == Schema Information
#
# Table name: baskets
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  note         :text
#  lock_version :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#
