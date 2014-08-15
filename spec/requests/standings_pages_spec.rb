require 'spec_helper'

describe 'Standings' do

  before{
    @week    = FactoryGirl.create(:week)
  }

  describe 'shows standing page' do
    it 'works! (now write some real specs)' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      @standing = FactoryGirl.create(:standing, week: @week)
      get standing_path(@standing)
      response.status.should be(200)
    end
  end

  context 'admin manages standings' do
    before {
      login_admin
      visit week_path(@week)
    }

    it 'gets info about tiers' do
      page.should have_content(/Standings/)
      page.should have_content(/No teams registered yet/)
      page.should have_link('Add team')
    end

    it 'can add a team' do
      click_link 'Add team'

      fill_in 'Name', with: 'SName'
      fill_in 'Captain', with: 'SCAptain'
      fill_in 'Rank', with:  1
      fill_in 'Tier', with: 1
      click_button 'Create Standing'

      page.should_not have_content(/hibited this team from being saved/)
      page.should have_content(/ was successfully added to registration./)
      page.should have_content('to fix setup')
      page.should_not have_button('Save settings')
    end

    it 'can edit a tier' do
      FactoryGirl.create(:standing, week: @week)
      visit week_path(@week)
      click_link 'Edit'
      fill_in 'Tier', with: 2
      click_button 'Update Standing'
      page.should have_content(/was successfully updated./)
      page.should have_content('to fix setup')
    end

    it 'next tier displays default tier#'

    it 'can destroy a tier' do
      FactoryGirl.create(:standing, week: @week)
      visit week_path(@week)
      click_link 'Destroy'
      page.should have_content(/was successfully removed/)
      page.should_not have_content('to fix setup')
    end
  end

end
