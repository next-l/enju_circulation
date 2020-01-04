require_dependency EnjuBiblio::Engine.config.root.join('app', 'models', 'carrier_type.rb').to_s

class CarrierType < ApplicationRecord
  include EnjuCirculation::EnjuCarrierType
end

# == Schema Information
#
# Table name: carrier_types
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  attachment_file_name      :string
#  attachment_content_type   :string
#  attachment_file_size      :bigint
#  attachment_updated_at     :datetime
#  display_name_translations :jsonb            not null
#
