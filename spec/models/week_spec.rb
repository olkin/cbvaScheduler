require 'spec_helper'

describe Week do

  let(:week) {FactoryGirl.build(:week)}

  it "should be valid" do
    week.should be_valid
  end

  it "can have unspecified week_nr" do
    week.week = nil
    week.should be_valid
  end


  let(:league) {FactoryGirl.create(:league)}
  let(:teams_2) {FactoryGirl.create_list(:team, 2, league: league)}
  let(:tier_setting) {FactoryGirl.build(:tier_setting, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)}

  let(:week_1_tier) {FactoryGirl.create(:week,
                                        settings: [tier_setting],
                                        standings: teams_2.map{|team| team.id},
                                        league: league
  )}

  it "1 tier default is valid" do
    week_1_tier.should be_valid
  end

  it "can't have same week nr for same league" do
    week.save
    week2 = week.dup
    week2.should_not be_valid
  end

  it "number of registered teams should not be less of teams in tiers " do
    week_1_tier.standings.pop
    week_1_tier.should_not be_valid
  end

  it "number of registered teams should not be more of teams in tiers " do
    team3 = FactoryGirl.create(:team)
    week_1_tier.standings.push(team3.id)
    week_1_tier.should_not be_valid
  end

  it "standings should have unique teams" do
    week_1_tier.standings.push(teams_2[0].id)
    week_1_tier.should_not be_valid
  end

  it "standings should not have empty spots" do
    week_1_tier.standings.insert(1,nil)
    week_1_tier.should_not be_valid
  end

  let(:teams_4) {FactoryGirl.create_list(:team, 4, league: league)}

  let(:tier_setting_1) {FactoryGirl.build(:tier_setting, total_teams: 2, teams_down: 1, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)}
  let(:week_2_tiers) {FactoryGirl.create(:week,
                                        settings: [tier_setting_1, tier_setting],
                                        standings: teams_4.map{|team| team.id},
                                        league: league
  )}

  it "default week with 2 tiers is valid" do
    week_2_tiers.should be_valid
  end

  it "settings for a tier should not be missing" do
      week_2_tiers.settings[0] = nil
      week_2_tiers.should_not be_valid
  end

  it "does not allow nil tier settings for last tiers" do
    week_2_tiers.settings[2] = nil
    week_2_tiers.should_not be_valid
  end

  it "when number of teams to move down is more than total number of teams" do
    week_2_tiers.settings[0].teams_down = 3
    week_2_tiers.should_not be_valid
  end

  it "doesn't accept number of up as 0" do
    week_2_tiers.settings[0].teams_down = 0
    week_2_tiers.should_not be_valid
  end

  it "doesn't allow different number of cycles in tiers" do
    week_2_tiers.settings[0].schedule_pattern[1] = week_2_tiers.settings[0].schedule_pattern[0].dup
    week_2_tiers.should_not be_valid
  end

  let(:teams_6) {FactoryGirl.create_list(:team, 6, league: league)}

  let(:week_3_tiers) {FactoryGirl.create(:week,
                                         settings: [tier_setting_1, tier_setting_1, tier_setting],
                                         standings: teams_6.map{|team| team.id},
                                         league: league
  )}

  it "default week for 3 tiers is valid" do
    week_3_tiers.should be_valid
  end

  it "number of teams to move up+down is more than total number of teams" do
    week_3_tiers.settings[0].teams_down = 2
    week_3_tiers.settings[1].teams_down = 2
    week_3_tiers.should_not be_valid
  end
end
