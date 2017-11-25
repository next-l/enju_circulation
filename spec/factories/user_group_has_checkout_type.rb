FactoryBot.define do
  factory :user_group_has_checkout_type do |f|
    f.user_group_id { FactoryBot.create(:user_group).id }
    f.checkout_type_id { FactoryBot.create(:checkout_type).id }
  end
end
