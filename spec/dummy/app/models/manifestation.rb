class Manifestation < ActiveRecord::Base
  include EnjuCirculation::Manifestation
  belongs_to :carrier_type
  has_many :exemplifies, :foreign_key => 'manifestation_id'
  has_many :items, :through => :exemplifies
  has_many :reserves, :foreign_key => :manifestation_id

  searchable do
    boolean :reservable do
      items.for_checkout.exists?
    end
  end
end
