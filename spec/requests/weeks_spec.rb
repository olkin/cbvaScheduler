require 'spec_helper'

describe 'Weeks' do
  before {@week = FactoryGirl.create(:week)}

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
      page.should have_content(/Tiers Settings/)
      page.should have_content(/Standings/)
      page.should_not have_content(/No matches/)
    end
  end

  pending 'display real week with(out) matches'
end
