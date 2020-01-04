require_dependency EnjuBiblio::Engine.config.root.join('app', 'models', 'carrier_type.rb').to_s

class CarrierType < ApplicationRecord
  include EnjuCirculation::EnjuCarrierType
end

# == Schema Information
#
# Table name: carrier_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
