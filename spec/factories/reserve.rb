FactoryBot.define do
  factory :reserve do |f|
    before(:create) do |reserve|
      user = User.new(FactoryBot.attributes_for(:user))
      reserve.user = user
    end
    f.pickup_location { FactoryBot.create(:library) }
    f.manifestation_id { FactoryBot.create(:manifestation).id }
    #    f.user{FactoryBot.create(:user)}
  end
end
