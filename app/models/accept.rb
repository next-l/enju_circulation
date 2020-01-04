require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'accept.rb').to_s

class Accept < ApplicationRecord
  include EnjuCirculation::EnjuAccept
end

# == Schema Information
#
# Table name: accepts
#
#  id           :bigint           not null, primary key
#  basket_id    :bigint
#  item_id      :bigint
#  librarian_id :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
