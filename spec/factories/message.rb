FactoryBot.define do
  factory :message do |f|
    f.recipient { FactoryBot.create(:user).username }
    f.sender { FactoryBot.create(:librarian) }
    f.subject 'new message'
    f.body 'new message body is really short'
  end
end
