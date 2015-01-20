FactoryGirl.define do
  factory :message do |f|
    f.recipient{FactoryGirl.create(:profile).user.username}
    f.sender{FactoryGirl.create(:profile).user}
    f.subject 'new message'
    f.body 'new message body is really short'
  end
end
