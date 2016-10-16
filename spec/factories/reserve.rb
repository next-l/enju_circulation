FactoryGirl.define do
  factory :reserve do |f|
    before(:create) do |reserve|
      profile = FactoryGirl.create(:profile)
      user = User.new(FactoryGirl.attributes_for(:user))
      user.profile = profile
      reserve.user = user
    end
    f.manifestation_id{FactoryGirl.create(:manifestation).id}
#    f.user{FactoryGirl.create(:user)}
  end
end
