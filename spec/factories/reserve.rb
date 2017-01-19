FactoryGirl.define do
  factory :reserve do |f|
    before(:create) do |reserve|
      user = User.new(FactoryGirl.attributes_for(:user))
      reserve.user = user
    end
    f.pickup_location { FactoryGirl.create(:library) }
    f.manifestation_id { FactoryGirl.create(:manifestation).id }
    #    f.user{FactoryGirl.create(:user)}
  end
end
