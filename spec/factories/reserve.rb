FactoryBot.define do
  factory :reserve do
    before(:create) do |reserve|
      profile = FactoryBot.create(:profile)
      user = User.new(FactoryBot.attributes_for(:user))
      user.profile = profile
      reserve.user = user
    end
    after(:build) do |reserve|
      item = FactoryBot.create(:item, use_restriction: UseRestriction.find_by(name: 'Available On Shelf'))
      reserve.manifestation = item.manifestation
      reserve.item = item
    end
  end
end
