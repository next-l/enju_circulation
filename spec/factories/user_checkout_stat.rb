FactoryBot.define do
  factory :user_checkout_stat do
    start_date { 1.week.ago }
    end_date { 1.day.ago }
    association :user, factory: :librarian
  end
end
