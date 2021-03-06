require 'rails_helper'

describe ItemsController do
  fixtures :all

  def valid_attributes
    FactoryBot.attributes_for(:item)
  end

  describe 'POST create' do
    before(:each) do
      manifestation = FactoryBot.create(:manifestation)
      @attrs = FactoryBot.attributes_for(:item, manifestation_id: manifestation.id)
      @invalid_attrs = { item_identifier: '無効なID', manifestation_id: manifestation.id }
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'should create reserved item' do
        post :create, params: { item: { circulation_status_id: 1, manifestation_id: 2 } }
        expect(assigns(:item)).to be_valid

        expect(response).to redirect_to item_url(assigns(:item))
        flash[:message].should eq I18n.t('item.this_item_is_reserved')
        assigns(:item).manifestation.should eq Manifestation.find(2)
        assigns(:item).should be_retained
      end

      it "should create another item with already retained" do
        reserve = FactoryBot.create(:reserve)
        reserve.transition_to!(:requested)
        post :create, params: { item: FactoryBot.attributes_for(:item, manifestation_id: reserve.manifestation.id) }
        expect(assigns(:item)).to be_valid
        expect(response).to redirect_to item_url(assigns(:item))
        post :create, params: { item: FactoryBot.attributes_for(:item, manifestation_id: reserve.manifestation.id) }
        expect(assigns(:item)).to be_valid
        expect(response).to redirect_to item_url(assigns(:item))
      end
    end
  end

  describe 'PUT update' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'should remove an item' do
        item = FactoryBot.create(:item)
        put :update, params: { id: item.id, item: {circulation_status_id: CirculationStatus.find_by(name: 'Removed').id } }
        expect(assigns(:item).valid?).to be_truthy
        expect(response).to redirect_to item_url(assigns(:item))
      end

      it 'should not remove a reserved item' do
        item = FactoryBot.create(:reserve).item
        put :update, params: { id: item.id, item: {circulation_status_id: CirculationStatus.find_by(name: 'Removed').id } }
        expect(assigns(:item).valid?).to be_falsy
        expect(response).to be_successful
      end
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'should remove an item' do
        item = FactoryBot.create(:item)
        put :update, params: { id: item.id, item: {circulation_status_id: CirculationStatus.find_by(name: 'Removed').id } }
        expect(assigns(:item).valid?).to be_truthy
        expect(response).to redirect_to item_url(assigns(:item))
      end

      it 'should not remove a reserved item' do
        item = FactoryBot.create(:reserve).item
        put :update, params: { id: item.id, item: {circulation_status_id: CirculationStatus.find_by(name: 'Removed').id } }
        expect(assigns(:item).valid?).to be_falsy
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @item = FactoryBot.create(:item)
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'should not destroy item if not checked in' do
        delete :destroy, params: { id: 1 }
        expect(response).to be_forbidden
      end

      it 'should not destroy a removed item' do
        delete :destroy, params: { id: 26 }
        expect(response).to be_forbidden
      end
    end
  end
end
