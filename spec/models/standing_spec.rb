require 'spec_helper'

describe Standing do
  before do
    @standing = FactoryGirl.create(:standing)
  end

  it {@standing.should be_valid}

  it "when 2 teams from different leagues can have same rank" do
    team2 = FactoryGirl.create(:team)
    FactoryGirl.create(:standing, team: team2).should be_valid
  end

  it "same team can have different standings on diff weeks" do
    week2 = FactoryGirl.create(:week, league: @standing.league, week: 2)
    FactoryGirl.create(:standing, team: @standing.team, week: week2).should be_valid
  end

  describe "invalid standings" do
    it "when week is missing" do
      @standing.week = nil
      @standing.should_not be_valid
    end

    it "when 2 teams from same league has same rank for same week" do
      team2 = FactoryGirl.create(:team, league: @standing.league)
      FactoryGirl.build(:standing, team: team2, week: @standing.week).should_not be_valid
    end

    it "same team can't have 2 standings for same week" do
       FactoryGirl.build(:standing, team: @standing.team, week: @standing.week, rank: @standing.rank + 1).should_not be_valid
    end

    it "when rank is missing" do
      @standing.rank = nil
      @standing.should_not be_valid
    end

    it "when rank is 0" do
      @standing.rank = 0
      @standing.should_not be_valid
    end

    it "when tier is missing/invalid" do
      invalid_tiers = [nil, 0]
      invalid_tiers.each{ |invalid_tier|
        @standing.tier = invalid_tier
        @standing.should_not be_valid
      }
    end
  end
end
