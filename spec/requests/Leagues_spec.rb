require 'spec_helper'

describe "Leagues" do

  subject { page }

  describe "GET /Leagues" do
    it "works!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get leagues_path
      response.status.should be(200)
    end
  end

  describe "league page" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team1) { FactoryGirl.create(:team, league: league, name: "Team1") }
    let!(:team2) { FactoryGirl.create(:team, league: league, name: "Team2") }
    before { visit league_path(league) }

    it { should have_content(league.description) }
    it { should have_title(league.description) }

    describe "teams" do
      it { should have_content(team1.name) }
      it { should have_content(team2.name) }
      it { should have_content(league.teams.count) }
    end
  end


end
