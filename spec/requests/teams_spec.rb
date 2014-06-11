require 'spec_helper'

describe "Teams" do
  subject { page }
  let(:league) { FactoryGirl.create(:league) }

  describe "GET /teams" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get league_teams_path(league)
      response.status.should be(200)
    end
  end

  describe "team page" do
    before{
      @team1 = FactoryGirl.create(:team, league: league, name: "Team1")
      @team2 = FactoryGirl.create(:team, league: league, name: "Team2")
      visit league_teams_path(league)
    }

      it { should have_content(@team1.name) }
      it { should have_content(@team2.name) }
      it { should have_content(league.teams.count) }
  end

  describe "team creation" do
    before {visit league_teams_path(league)}
    it "should not create a team" do
      expect { click_link "Add Team" }.not_to change(Team, :count)
    end

    context "with information" do
      before { click_link "Add Team"}

      describe "with invalid information" do

        describe "error messages" do
          before { click_button "Create Team"}
          it { should have_content('error') }
        end
      end

      describe "with valid information" do

        before do
          valid_attributes = FactoryGirl.attributes_for(:team)
          fill_in "Name",    with: valid_attributes[:name]
          fill_in "Captain", with: valid_attributes[:captain]
        end

        it "should create a team" do
          expect { click_button "Create Team" }.to change(Team, :count).by(1)
        end
      end
    end
  end

end

