require 'rails_helper'

describe DemandsController do
  fixtures :all

  def mock_user(stubs = {})
    (@mock_user ||= mock_model(Demand).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  describe 'GET index' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns all demands as @demands' do
        get :index
        assigns(:demands).should eq Demand.order(created_at: :desc).page(1)
        response.should be_success
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns all demands as @demands' do
        get :index
        assigns(:demands).should eq Demand.order(created_at: :desc).page(1)
        response.should be_success
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'should not assign all demands as @demands' do
        get :index
        assigns(:demands).should be_nil
        response.should be_forbidden
      end
    end
  end

  describe 'GET show' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested demand as @demand' do
        demand = FactoryGirl.create(:demand)
        get :show, params: { id: demand.id }
        assigns(:demand).should eq(demand)
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested demand as @demand' do
        demand = FactoryGirl.create(:demand)
        get :show, params: { id: demand.id }
        assigns(:demand).should eq(demand)
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns the requested demand as @demand' do
        demand = FactoryGirl.create(:demand)
        get :show, params: { id: demand.id }
        assigns(:demand).should eq(demand)
        response.should be_forbidden
      end
    end

    describe 'When not logged in' do
      it 'assigns the requested demand as @demand' do
        demand = FactoryGirl.create(:demand)
        get :show, params: { id: demand.id }
        assigns(:demand).should eq(demand)
        response.should redirect_to new_user_session_url
      end
    end
  end

  describe 'GET new' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested demand as @demand' do
        get :new
        assigns(:demand).should_not be_valid
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested demand as @demand' do
        get :new
        assigns(:demand).should_not be_valid
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'should not assign the requested demand as @demand' do
        get :new
        assigns(:demand).should be_nil
        response.should be_forbidden
      end
    end

    describe 'When not logged in' do
      it 'should not assign the requested demand as @demand' do
        get :new
        assigns(:demand).should be_nil
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST create' do
    before(:each) do
      @attrs = { item_identifier: '00003' }
      @invalid_attrs = { item_id: 'invalid' }
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      describe 'with valid params' do
        it 'assigns a newly created demand as @demand' do
          post :create, params: { demand: @attrs }
          assigns(:demand).should be_valid
        end
      end

      describe 'with invalid params' do
        it 'assigns a newly created but unsaved demand as @demand' do
          post :create, params: { demand: @invalid_attrs }
          assigns(:demand).should_not be_valid
        end

        it 'assigns the requested demand as @demand' do
          post :create, params: { demand: @invalid_attrs }
          assigns(:demand).should_not be_valid
          response.should be_success
        end
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      describe 'with valid params' do
        it 'assigns a newly created demand as @demand' do
          post :create, params: { demand: @attrs }
          assigns(:demand).should be_valid
        end
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      describe 'with valid params' do
        it 'assigns a newly created demand as @demand' do
          post :create, params: { demand: @attrs }
          assigns(:demand).should be_nil
        end

        it 'should be forbidden' do
          post :create, params: { demand: @attrs }
          response.should be_forbidden
        end
      end
    end

    describe 'When not logged in' do
      before(:each) do
        @attrs = { item_id: 3, user_id: 2 }
        @invalid_attrs = { item_id: 'invalid' }
      end

      describe 'with valid params' do
        it 'assigns a newly created demand as @demand' do
          post :create, params: { demand: @attrs }
        end

        it 'should redirect to new session url' do
          post :create, params: { demand: @attrs }
          response.should redirect_to new_user_session_url
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @demand = FactoryGirl.create(:demand)
    end

    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'destroys the requested demand' do
        delete :destroy, params: { id: @demand.id }
      end

      it 'redirects to the demands list' do
        delete :destroy, params: { id: @demand.id }
        response.should redirect_to(demands_url)
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'destroys the requested demand' do
        delete :destroy, params: { id: @demand.id }
      end

      it 'redirects to the demands list' do
        delete :destroy, params: { id: @demand.id }
        response.should redirect_to(demands_url)
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'destroys the requested demand' do
        delete :destroy, params: { id: @demand.id }
      end

      it 'should be forbidden' do
        delete :destroy, params: { id: @demand.id }
        response.should be_forbidden
      end
    end

    describe 'When not logged in' do
      it 'destroys the requested demand' do
        delete :destroy, params: { id: @demand.id }
      end

      it 'should be forbidden' do
        delete :destroy, params: { id: @demand.id }
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
