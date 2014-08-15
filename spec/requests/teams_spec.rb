require 'spec_helper'

describe 'Teams' do
  subject { page }
  let(:league) { FactoryGirl.create(:league) }

  describe 'GET league/teams' do
    it 'works! ' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get league_teams_path(league)
      response.status.should be(200)
    end

    it 'get all teams for admin' do
      login_admin
      get teams_path
      response.status.should be(200)
    end

  end

  describe 'teams page' do
    before{
      @team1 = FactoryGirl.create(:team, league: league, name: 'Team1')
      @team2 = FactoryGirl.create(:team, league: league, name: 'Team2')
      visit league_teams_path(league)
    }

      it { should have_content(@team1.name) }
      it { should have_content(@team2.name) }
      it { should have_content(league.teams.count) }
  end

  describe 'team page' do
    before{
      @team1 = FactoryGirl.create(:team, league: league, name: 'TName', captain: 'CName')
      visit team_url(@team1)
    }

    it { should have_content(/TName/) }
    it { should have_content(/CName/) }
  end

  describe 'team page with standing' do
    before{
      @week = FactoryGirl.create(:week)
      team = FactoryGirl.build(:team,  name: 'TName', captain: 'CName', league: @week.league)
      @standing = FactoryGirl.create(:standing, team: team, tier: 3, rank: 1, week: @week)
      visit team_url(@standing.team)
    }

    it { should have_content(/TName/) }
    it { should have_content(/CName/) }
    it { should have_content(/3/) }
    it { should have_content(/1/) }
  end

end

