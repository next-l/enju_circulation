FactoryGirl.define do
  factory :profile, :class => Profile do |f|
    f.user_group_id {UserGroup.first.id}
    f.required_role_id {Role.where(name: 'User').first.id}
    f.sequence(:user_number){|n| "user_number_#{n}"}
    f.library_id 2
    f.locale "ja"
    after(:create) do |profile|
      user = FactoryGirl.create(:user)
      profile.user = user
      profile.save
    end
  end
end
