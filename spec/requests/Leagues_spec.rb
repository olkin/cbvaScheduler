require 'spec_helper'

describe 'leagues' do

  subject { page }

  describe 'GET /leagues' do
    it 'works!' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get leagues_path
      response.status.should be(200)
    end

    it 'no editing actions for non-admins' do
      visit leagues_path
      page.should_not have_content('New event')
    end

    it 'admin can create a new league' do
      login_admin

      visit leagues_path
      page.should have_content('New event')

    end

    context 'a league is registered' do
      before {
        @league = FactoryGirl.create(:league)
        visit leagues_path
      }

      it 'only admin can edit a league' do
        page.should_not have_content('Edit')
        page.should_not have_content('Destroy')

        login_admin
        visit leagues_path
        page.should have_content('Edit')
        page.should have_content('Destroy')
      end
    end
  end

  describe 'league page' do
    before {
      @league = FactoryGirl.create(:league)
      get league_path(@league)
    }

    it { response.status.should be 302}
    it { response.should redirect_to league_weeks_path(@league)}
  end
end
