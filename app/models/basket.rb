require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'basket.rb').to_s

class Basket < ApplicationRecord
  include EnjuCirculation::EnjuBasket
end

# == Schema Information
#
# Table name: baskets
#
#  id           :bigint           not null, primary key
#  user_id      :bigint
#  note         :text
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
