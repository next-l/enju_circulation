FactoryBot.define do
  factory :reserve_stat_has_user do |f|
    f.user_reserve_stat_id{FactoryBot.create(:user_reserve_stat).id}
    f.user_id{FactoryBot.create(:user).id}
  end
end
