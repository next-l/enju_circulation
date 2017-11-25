# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :demand do
    user_id { FactoryBot.create(:user).id }
    item_id { FactoryBot.create(:item).id }
    message_id { FactoryBot.create(:message).id }
  end
end
