FactoryBot.define do
  factory :manifestation_reserve_stat do
    start_date { 1.week.ago }
    end_date { 1.day.ago }
    association :user, factory: :librarian
  end
end
