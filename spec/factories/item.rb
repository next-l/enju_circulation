FactoryBot.define do
  factory :item do
    sequence(:item_identifier){|n| "item_#{n}"}
    circulation_status_id{CirculationStatus.find(1).id} if defined?(EnjuCircuation)
    manifestation_id{FactoryBot.create(:manifestation).id}
    association :bookstore
    association :budget_type
    after(:create) do |item|
      item.use_restriction = UseRestriction.find_by(name: 'Limited Circulation, Normal Loan Period')
    end
  end
end
