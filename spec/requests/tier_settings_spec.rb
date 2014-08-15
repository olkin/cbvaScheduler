require 'spec_helper'

describe 'TierSettings' do
  before {
    @week = FactoryGirl.create(:week)
    @tier_setting = FactoryGirl.build(:tier_setting, week: @week)
  }

  context 'admin manages tiers' do
    before {
      login_admin
      visit week_path(@week)
    }

    it 'gets info about tiers' do
      page.should have_content(/Tiers Settings/)
      page.should have_content(/Tiers are not set up/)
      page.should have_link('Add Tier')

    end

    it 'can add a tier' do
      click_link 'Add Tier'

      fill_in 'Tier', with: 1
      fill_in 'Total teams', with: @tier_setting.total_teams
      fill_in 'Teams down', with: @tier_setting.teams_down
      select @tier_setting.day, from: 'Day'
      fill_in 'Cycle', with: @tier_setting.cycle
      fill_in 'Schedule pattern', with: @tier_setting.schedule_pattern.to_s
      fill_in 'Set points', with: @tier_setting.set_points.to_s
      fill_in 'Match times', with: @tier_setting.match_times.to_s
      click_button 'Create Tier setting'

      page.should_not have_content(/prohibited this tier_setting from being saved/)
      page.should have_content(/ were added successfully./)
      page.should have_content('to fix setup')
      page.should_not have_button('Save settings')
    end

    it 'can edit a tier' do
      @tier_setting.save!
      visit week_path(@week)
      click_link 'Edit'
      fill_in 'Tier', with: 2
      click_button 'Update Tier setting'
      page.should have_content(/were successfully updated./)
      page.should have_content('to fix setup')
    end

    it 'next tier has default tier#'

    it 'can destroy a tier' do
      @tier_setting.save!
      visit week_path(@week)
      click_link 'Destroy'
      page.should have_content(/were successfully removed./)
      page.should_not have_content('to fix setup')
    end
  end
end
