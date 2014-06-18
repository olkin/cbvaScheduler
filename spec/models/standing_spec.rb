require 'spec_helper'

describe Standing do
  before do
    @team = FactoryGirl.create(:team)
    @tier_settings = FactoryGirl.create(:tier_setting, league: @team.league)
    @standing = FactoryGirl.create(:standing, team: @team)
  end

  it {@standing.should be_valid}

  it "when 2 teams from different leagues can have same rank" do
    league2 = FactoryGirl.create(:league, desc: "another league")
    tier_settings = FactoryGirl.create(:tier_setting, league: league2)
    team2 = FactoryGirl.create(:team, league: league2, name: "Another name")
    FactoryGirl.create(:standing, team: team2).should be_valid
  end

  it "same team can have different standings on diff weeks" do
    FactoryGirl.create(:standing, team: @team, week:2).should be_valid
  end

  describe "invalid standings" do
    it "when week is missing" do
      @standing.week = nil
      @standing.should_not be_valid
    end

    it "when 2 teams from same league has same rank" do
      team2 = FactoryGirl.create(:team, league: @team.league, name: "Another name")
      FactoryGirl.build(:standing, team: team2).should_not be_valid
    end

    it "same team can't have 2 standings for same week" do
       FactoryGirl.build(:standing, team: @team).should_not be_valid
    end

    it "when tier is missing" do
      @standing.tier = nil
      @standing.should_not be_valid
    end

    it "when tier is 0" do
      @standing.tier = 0
      @standing.should_not be_valid
    end

    it "when tier is > than number of tiers in the league" do
      @standing.tier = 3
      @standing.should_not be_valid
    end

    it "when rank is missing" do
      @standing.rank = nil
      @standing.should_not be_valid
    end

    it "when rank is > than number of teams for league" do
      @standing.rank = 3
      @standing.should_not be_valid
    end

    it "when rank is 0" do
      @standing.rank = 0
      @standing.should_not be_valid
    end
  end
end
