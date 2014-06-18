require 'spec_helper'

describe League do
  let (:league) {FactoryGirl.build(:league) }

  subject { league }

  it { should respond_to(:desc) }
  it { should respond_to(:description) }
  it { should respond_to(:start_date)}
  it { should respond_to(:teams) }
  it { should respond_to(:tier_settings)}

  describe "when desc is not present" do
    before { league.desc = " " }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { league.description = " " }
    it { should_not be_valid }
  end

  describe "when desc is already taken" do
    before do
      league_with_same_desc = league.dup
      league_with_same_desc.save
    end

    it { should_not be_valid }
  end

  describe "when tier is missing" do
    before{
      league.save!
      FactoryGirl.create(:tier_setting, league: league, tier: 2)
    }

    it {league.validate_settings.should_not be_true}

  end

  describe "when number of teams to move down is more than total number of teams" do
    before{
      league.save!
      FactoryGirl.create(:tier_setting, league: league, tier: 1, total_teams: 4, teams_down: 3, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[4].to_s)
      FactoryGirl.create(:tier_setting, league: league, tier: 2, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].to_s)
    }

    it {league.validate_settings.should_not be_true}
  end

  describe "when number of teams to move up+down is more than total number of teams" do
    before{
      league.save!
      FactoryGirl.create(:tier_setting, league: league, tier: 1, total_teams: 4, teams_down: 2, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[4].to_s)
      FactoryGirl.create(:tier_setting, league: league, tier: 2, total_teams: 2, teams_down: 2, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].to_s)
      FactoryGirl.create(:tier_setting, league: league, tier: 3, total_teams: 2, teams_down: 2, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].to_s)
    }

    it {league.validate_settings.should_not be_true}
  end

  describe "when number of up is 0" do
    before{
      league.save!
      FactoryGirl.create(:tier_setting, league: league, tier: 1, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].to_s)
      FactoryGirl.create(:tier_setting, league: league, tier: 2, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].to_s)
    }

    it {league.validate_settings.should_not be_true}

  end

  describe "when number of cycles differ in tiers" do
    before{
      league.save!
      double_cycles = League::DEFAULT_SCHEDULE_PATTERNS[2]*2
      FactoryGirl.create(:tier_setting, league: league, tier: 1)
      FactoryGirl.create(:tier_setting, league: league, tier: 2, schedule_pattern: double_cycles.to_s)
      #league.validate_settings
    }

    it {league.validate_settings.should_not be_true}
  end

  describe "when number of registered teams is different from number of teams in tiers " do
    before{
      league.save!
      FactoryGirl.create(:tier_setting, league: league, tier: 1, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].to_s)
    }

    it {league.validate_registration.should_not be_true}
  end

  describe "when number of registered teams same as number of teams in tiers " do
    before{
      league.save!
      FactoryGirl.create(:tier_setting, league: league, tier: 1, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].to_s)
      FactoryGirl.create(:team, name: "Team1", league: league)
      FactoryGirl.create(:team, name: "Team2", league: league)
    }

    it {league.validate_registration.should be_true}
  end

end
