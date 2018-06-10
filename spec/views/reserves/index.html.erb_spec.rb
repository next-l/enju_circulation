require 'rails_helper'

describe "reserves/index" do
  fixtures :users, :roles, :user_has_roles, :reserves

  before(:each) do
    view.extend EnjuLeaf::EnjuLeafHelper

    assign(:reserves, Reserve.page(1))
    view.stub(:current_user).and_return(User.where(username: 'enjuadmin').first)
    view.stub(:params).and_return(ActionController::Parameters.new)
  end

  it "renders a list of reserves" do
    allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(1)", text: reserves(:reserve_00001).id.to_s
    assert_select "tr>td:nth-child(2)", text: /#{reserves(:reserve_00001).user.username}/
    assert_select "tr>td:nth-child(2)", text: /#{reserves(:reserve_00002).manifestation.original_title}/
  end

  it "renders a list of reserves when a reserve does not have expired_at" do
    reserve = FactoryBot.create(:reserve, expired_at: nil)
    assign(:reserves, Reserve.page(2))
    allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    render
    rendered.should match /<td/
  end
end
