FactoryBot.define do
  factory :item_has_use_restriction do |f|
    f.item_id { FactoryBot.create(:item).id }
    f.use_restriction_id { FactoryBot.create(:use_restriction).id }
  end
end
