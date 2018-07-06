FactoryBot.define do
  factory :reserve do
    before(:create) do |reserve|
      profile = FactoryBot.create(:profile)
      user = User.new(FactoryBot.attributes_for(:user))
      user.profile = profile
      reserve.user = user
    end
    manifestation_id{FactoryBot.create(:manifestation).id}
  end
end
