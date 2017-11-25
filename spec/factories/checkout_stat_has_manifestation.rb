FactoryBot.define do
  factory :checkout_stat_has_manifestation do |f|
    f.manifestation_checkout_stat_id { FactoryBot.create(:manifestation_checkout_stat).id }
    f.manifestation_id { FactoryBot.create(:manifestation).id }
  end
end
