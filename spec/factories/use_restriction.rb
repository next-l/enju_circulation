FactoryBot.define do
  factory :use_restriction do |f|
    f.sequence(:name){|n| "use_restriction_#{n}"}
    f.sequence(:display_name_en){|n| "use_restriction_#{n}"}
    f.sequence(:display_name_ja){|n| "use_restriction_#{n}"}
  end
end
