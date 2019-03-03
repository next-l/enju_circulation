FactoryBot.define do
  factory :manifestation do |f|
    f.sequence(:original_title){|n| "manifestation_title_#{n}"}
    f.carrier_type_id{CarrierType.find_by(name: 'volume').id}
  end

  factory :manifestation_serial, class: Manifestation do |f|
    f.sequence(:original_title){|n| "manifestation_title_#{n}"}
    f.carrier_type_id{ CarrierType.find_by(name: 'volume').id }
    f.language_id{Language.find(1).id}
    f.serial{true}
    f.series_statements{[FactoryBot.create(:series_statement_serial)]}
  end
end
