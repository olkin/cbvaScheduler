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

    it 'doesn\'t display any event' do
      visit leagues_path
      page.should have_content('No open events')

      click_link 'Leagues'
      page.should have_content('No open events')

      page.should_not have_button('Search')
    end


    context 'admin\'s actions:' do
      before{
        login_admin
        visit leagues_path

        click_link 'Add event'

        @league = FactoryGirl.build(:league, description: 'AnyName')
        fill_in 'Desc', with: @league.desc
        fill_in 'Description', with: 'AnyName'
        click_button 'Create League'
      }

      it 'creates a league' do
        page.should have_content('Event AnyName was successfully created')
        page.should have_selector('ul>li')

        page.should_not have_content('No open events')
        page.should have_content('Add event')
        page.should have_button('Search')
      end

      it 'edits existing league' do
        click_link 'Edit'
        fill_in 'Description', with: 'AnotherName'
        click_button 'Update League'

        page.should have_content('Event AnotherName was successfully updated')
        page.should have_content('AnotherName')
      end

      it 'removes existing league' do
        click_link 'Destroy'
        page.should have_content('Event AnyName was successfully destroyed')
        page.should have_content('No open events')
      end

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

      it 'searches team by name' do
        visit leagues_path
        fill_in 'search', with: 'team'
        click_button 'Search'

        page.should have_content('Search results')
        #TODO: check that 'team' is displayed in search text field
        page.should have_content('No results')
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
