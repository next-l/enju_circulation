require 'spec_helper'

describe 'checkouts/index' do
  fixtures :users, :roles, :user_has_roles

  before(:each) do
    assign(:checkouts, Checkout.page(1))
    assign(:checkouts_facet, [])
    view.stub(:current_user).and_return(User.where(username: 'enjuadmin').first)
  end

  it 'renders a list of checkouts' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/これからの生命科学研究者のためのバイオ特許入門講座/)
  end
end
