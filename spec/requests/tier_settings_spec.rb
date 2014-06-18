require 'spec_helper'

describe "TierSettings" do
  let(:league) {FactoryGirl.create(:league)}
  subject { page }
  describe "GET /tier_settings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get league_tier_settings_path(league)
      response.status.should be(200)
    end
  end


  describe " view settings" do
    before {visit league_path(league)}
    it "should show settings" do
      click_link "Settings"
      page.should have_title("Settings")
      page.should have_title(league.description)
      page.should have_link('Teams', href: league_teams_path(league))
      page.should have_link('League', href: league_path(league))

    end
  end

  describe "league setup with info" do
    before(:each) do
      visit new_league_tier_setting_path(league)
    end

    describe "with invalid info shows error messages" do
      before { click_button "Create Tier"}
      it { should have_content('error') }
    end

    describe "with valid info" do
      before do
        valid_attributes = FactoryGirl.attributes_for(:tier_setting)
        fill_in "Tier",    with: valid_attributes[:tier]
        select valid_attributes[:day], from: "Day"
        fill_in "Schedule pattern", with: valid_attributes[:schedule_pattern]
      end

      it "should create a team" do
        expect { click_button "Create Tier"}.to change(TierSetting, :count).by(1)
      end

    end

    end
end
