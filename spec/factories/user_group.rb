FactoryBot.define do
  factory :user_group do |f|
    f.sequence(:name) { |n| "user_group_#{n}" }
    f.sequence(:display_name) { |n| "user_group_#{n}" }
  end
end
