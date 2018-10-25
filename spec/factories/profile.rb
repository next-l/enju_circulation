FactoryBot.define do
  factory :profile, class: Profile do |f|
    f.user_group {UserGroup.first}
    f.required_role {Role.find_by_name('User')}
    f.sequence(:user_number){|n| "user_number_#{n}"}
    f.library {Library.find(2)}
    f.locale { "ja" }
  end
end
