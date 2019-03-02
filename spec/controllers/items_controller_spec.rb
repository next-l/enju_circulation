require 'rails_helper'

describe ItemsController do
  fixtures :all

  def valid_attributes
    FactoryBot.attributes_for(:item)
  end

  describe 'DELETE destroy' do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'should not destroy item if not checked in' do
        delete :destroy, params: { id: items(:item_00001) }
        expect(response).to be_forbidden
      end
    end
  end
end
