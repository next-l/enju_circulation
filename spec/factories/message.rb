FactoryGirl.define do
  factory :message do |f|
    f.recipient { FactoryGirl.create(:user).username }
    f.sender { FactoryGirl.create(:librarian) }
    f.subject 'new message'
    f.body 'new message body is really short'
  end
end
