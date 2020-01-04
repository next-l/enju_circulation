require_dependency EnjuLibrary::Engine.config.root.join('app', 'models', 'accept.rb').to_s

class Accept < ApplicationRecord
  include EnjuCirculation::EnjuAccept
end

# == Schema Information
#
# Table name: accepts
#
#  id           :integer          not null, primary key
#  basket_id    :integer
#  item_id      :integer
#  librarian_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#
