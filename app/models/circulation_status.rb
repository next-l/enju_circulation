class CirculationStatus < ApplicationRecord
  include MasterModel
  validates :name, presence: true, format: { with: /\A[0-9A-Za-z][0-9A-Za-z_\-\s,]*[0-9a-z]\Z/ }

  scope :available_for_checkout, -> { where(name: 'Available On Shelf') }
  has_many :items
  translates :display_name

  private

  def valid_name?
    true
  end
end

# == Schema Information
#
# Table name: circulation_statuses
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
