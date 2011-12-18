class Manifestation < ActiveRecord::Base
  belongs_to :carrier_type
  has_many :exemplifies, :foreign_key => 'manifestation_id'
  has_many :items, :through => :exemplifies

  searchable do
    boolean :reservable do
      items.for_checkout.exists?
    end
  end
end
