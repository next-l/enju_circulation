FactoryBot.define do
  factory :checkout_type do
    sequence(:name){|n| "checkout_type_#{n}"}
    sequence(:display_name_en){|n| "checkout_type_#{n}"}
    sequence(:display_name_ja){|n| "checkout_type_#{n}"}
  end
end
