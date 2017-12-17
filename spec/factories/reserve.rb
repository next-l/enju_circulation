FactoryBot.define do
  factory :reserve do |f|
    before(:create) do |reserve|
      profile = FactoryBot.create(:profile)
      user = User.new(FactoryBot.attributes_for(:user))
      user.profile = profile
      reserve.user = user
    end
    f.manifestation_id{FactoryBot.create(:manifestation).id}
#    f.user{FactoryBot.create(:user)}
  end
end
