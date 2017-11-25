FactoryBot.define do
  factory :checkout_stat_has_user do |f|
    f.user_checkout_stat_id { FactoryBot.create(:user_checkout_stat).id }
    f.user_id { FactoryBot.create(:user).id }
  end
end
