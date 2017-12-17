FactoryBot.define do
  factory :lending_policy do |f|
    f.user_group_id{FactoryBot.create(:user_group).id}
    f.item_id{FactoryBot.create(:item).id}
  end
end
