FactoryBot.define do
  factory :item do
    sequence(:item_identifier){|n| "item_#{n}"}
    circulation_status_id{CirculationStatus.find(1).id}
    manifestation_id{FactoryBot.create(:manifestation).id}
    after(:build) do |item|
      bookstore = Bookstore.find(1)
      budget_type = BudgetType.find(1)
      item.use_restriction = UseRestriction.find_by(name: 'Limited Circulation, Normal Loan Period')
    end
  end
end
