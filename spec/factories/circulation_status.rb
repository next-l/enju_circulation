FactoryBot.define do
  factory :circulation_status do |f|
    f.sequence(:name){|n| "circulation_status_#{n}"}
    f.sequence(:display_name_en){|n| "circulation_status_#{n}"}
    f.sequence(:display_name_ja){|n| "circulation_status_#{n}"}
  end
end
