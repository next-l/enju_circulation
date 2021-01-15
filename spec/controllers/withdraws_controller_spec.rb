require 'rails_helper'

describe WithdrawsController do
  fixtures :all
  let(:valid_attributes) do
    FactoryBot.build(:withdraw).attributes.with_indifferent_access
  end
  let(:valid_create_attributes) do
    { basket_id: Basket.find(valid_attributes[:basket_id]).id,
      withdraw: { item_identifier: Item.find(valid_attributes[:item_id]).item_identifier }}
  end

  describe 'POST create' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'should not withdraw a reserved item' do
        expect do
          post :create, params: { basket_id: valid_create_attributes[:basket_id], withdraw: { item_identifier: reserves(:reserve_00014).item.item_identifier } }
        end.to change(Withdraw, :count).by(0)
        expect(assigns(:withdraw)).to be_a(Withdraw)
        expect(response).to be_successful
      end

      it 'should not withdraw a checked-out item' do
        post :create, params: { basket_id: valid_create_attributes[:basket_id], withdraw: { item_identifier: '00001' } }
        expect(assigns(:withdraw)).to be_a(Withdraw)
        expect(response).to be_successful
      end
    end
  end
end
