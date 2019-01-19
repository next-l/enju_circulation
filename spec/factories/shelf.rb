FactoryBot.define do
  factory :shelf do
    sequence(:name){|n| "shelf_#{n}"}
    association :library
  end
end
