# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :demand do
    user_id{FactoryGirl.create(:user).id}
    item_id{FactoryGirl.create(:item).id}
    message_id{FactoryGirl.create(:message).id}
  end
end
