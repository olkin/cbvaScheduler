require 'spec_helper'

describe 'Weeks' do
  before { @week = FactoryGirl.create(:week) }

  describe 'GET /weeks' do
    it 'works!' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get league_weeks_path(@week.league)
      response.status.should be(200)
    end
  end

  describe 'week page' do
    it 'works!' do
      visit week_path(@week)
      page.title.should match /#{@week.league.description}/
      page.should have_content(/No schedule available/)
      page.should_not have_content(/No matches/)
      page.should_not have_link('Settings')
      page.should_not have_link('PDF Schedules')
      page.should_not have_content(/Tiers Settings/)
      page.should_not have_link('Add Tier')

      page.should_not have_content(/Standings/)
      page.should_not have_content(/No teams registered yet/)
      page.should_not have_link('Add team')
    end

    it 'redirects to leagues' do
      visit league_weeks_path(@week.league)
      click_link 'All Events'
      page.should have_button('Search')
    end

    context 'admin actions' do
      before { login_admin }

      it 'shows settings ' do
        visit week_path(@week)
        page.should have_link('Settings')
        page.should_not have_link('PDF Schedules')
      end

      it 'allows to save valid week' do
        FactoryGirl.create(:tier_setting, week: @week)
        FactoryGirl.create(:standing, week: @week, rank: 1)
        FactoryGirl.create(:standing, week: @week, rank: 2)

        visit week_path(@week)
        page.should have_link('Save settings')
      end
    end


  end


  pending 'displays settings week'

  pending 'displays real week matches'

  pending 'disaplays real week settings'

end
