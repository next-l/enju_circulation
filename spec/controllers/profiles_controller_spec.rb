require 'rails_helper'

describe ProfilesController do
  fixtures :all

  describe 'GET show' do
    describe 'When logged in as User' do
      login_fixture_user

      it 'should show icalendar feed' do
        get :edit, id: profiles(:profile_user1).id, mode: 'feed_token'
        response.should render_template('profiles/_feed_token')
      end
    end
  end
end
