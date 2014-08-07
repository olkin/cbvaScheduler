require 'spec_helper'

describe Standing do
  before { @standing = FactoryGirl.create(:standing) }

  subject {@standing}
  it { should be_valid }
  it { should respond_to :team }
  it { should respond_to :tier }
  it { should respond_to :rank }
  it { should respond_to :week }
  it { should respond_to :matches_played }
  it { should respond_to :matches_won }
  it { should respond_to :sets_played }
  it { should respond_to :sets_won }
  it { should respond_to :points_diff }

  it 'team should not be nil' do
    @standing.team = nil
    @standing.should_not be_valid
  end

  it 'has a week it belongs to' do
    @standing.week = nil
    @standing.should_not be_valid
  end

  it 'team should belong to same league as week' do
    @standing.week.league = FactoryGirl.create(:league)
    @standing.should_not be_valid
  end

  it 'a team cannot have 2 standings for same week' do
    FactoryGirl.build(:standing, team: @standing.team, week: @standing.week, rank: @standing.rank + 1).should_not be_valid
  end

  it 'has valid tier' do
    invalid_tiers = [0, nil, -1]
    invalid_tiers.each do |tier|
      @standing.tier = tier
      @standing.should_not be_valid
    end
  end

  it 'has default statistics at the beginning' do
    @standing.matches_played.should eql 0
    @standing.matches_won.should eql 0
    @standing.sets_played.should eql 0
    @standing.sets_won.should eql 0
    @standing.points_diff.should eql 0
  end


  it 'invalid ranks' do
    invalid_ranks = [-1, 0, nil]
    invalid_ranks.each do |rank|
      @standing.rank = rank
      @standing.should_not be_valid
    end
  end

  it '2 teams from different leagues can have same rank/tier' do
    FactoryGirl.create(:standing).should be_valid
  end


  it '2 teams from different tiers can have same rank' do
    FactoryGirl.create(:standing, league: @standing.league, tier: @standing.tier + 1, week: @standing.week).should be_valid
  end

  it 'a team can have different standings on diff weeks' do
    week2 = FactoryGirl.create(:week, league: @standing.league, week: (@standing.week.week || -1) + 1 )
    FactoryGirl.create(:standing, team: @standing.team, week: week2).should be_valid
  end

  it 'rank  of a team is unique within week/league/tier' do
    FactoryGirl.build(:standing, week: @standing.week, league: @standing.league).should_not be_valid
  end

  it 'has access to tier settings' do
    @standing.tier_setting.should eql nil
    FactoryGirl.create(:tier_setting, week: @standing.week)

    @standing.tier_setting(true).should_not eql nil  #otherwise cached value is used
  end

  it 'has access to matches' do
    @standing.matches.should be_empty

    FactoryGirl.create(:tier_setting, week: @standing.week)
    match = FactoryGirl.create(:match, standing1: @standing)
    @standing.matches.should_not be_empty

    match.standing2.matches.should_not be_empty
  end

  it 'matches are destroyed if team is destroyed' do
    FactoryGirl.create(:tier_setting, week: @standing.week)
    FactoryGirl.create(:match, standing1: @standing)
    @standing.destroy

    Match.where(standing1_id: @standing.id).should be_empty
  end

end
