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

  it "cannot have negative week_nr" do
    week.week = -1
    week.should_not be_valid
  end

  it "can't have same week nr for same league" do
    week.save
    week2 = week.dup
    week2.should_not be_valid
  end

  context "1 tier 2 teams" do
    before(:each) do
      @week_1_tier = FactoryGirl.create(:week)
      @teams_2 = FactoryGirl.create_list(:team, 2, league: @week_1_tier.league)
      @tier_setting = FactoryGirl.create(:tier_setting, week: @week_1_tier, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)

      @teams_2.each_with_index{|team, idx|
        FactoryGirl.create(:standing, week: @week_1_tier, team: team, rank: idx + 1)}
    end

    it "1 tier default is valid" do
      @week_1_tier.should be_valid
    end

    it "number of registered teams should not be less of teams in tiers " do
      @week_1_tier.standings.last.destroy
      @week_1_tier.should_not be_valid
    end

    it "number of registered teams should not be more of teams in tiers " do
      team3 = FactoryGirl.create(:team)
      FactoryGirl.create(:standing, week: @week_1_tier, team: team3, rank: 3)
      @week_1_tier.should_not be_valid
    end

    it "settings for a tier should not be missing" do
      @tier_setting.update_attribute(:tier, 2)
      @week_1_tier.should_not be_valid
    end


    it "when rank is > than number of teams for league" do
      @week_1_tier.standings.last.update_attribute(:rank, 3)
      @week_1_tier.should_not be_valid
    end
  end

  context "2 tiers 4 teams" do
    before(:each) do
      @week_2_tiers = FactoryGirl.create(:week)
      @tier_setting = FactoryGirl.create(:tier_setting, week: @week_2_tiers, tier: 2, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)
      @tier_setting_1 = FactoryGirl.create(:tier_setting, week: @week_2_tiers, total_teams: 2,tier: 1, teams_down: 1, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)
      @teams_4 = FactoryGirl.create_list(:team, 4, league: @week_2_tiers.league)
      @teams_4.each_with_index{|team, idx|
        FactoryGirl.create(:standing, week: @week_2_tiers, team: team, rank: idx + 1)}
    end

    it "default week with 2 tiers is valid" do
      @week_2_tiers.should be_valid
    end

    it "doesn't accept number of up as 0" do
      @week_2_tiers.tier_settings.find_by_tier(1).update_attribute(:teams_down, 0)
      @week_2_tiers.should_not be_valid
    end

    it "doesn't allow different number of cycles in tiers" do
      setting_to_update = @week_2_tiers.tier_settings.find_by_tier(1)
      current_schedule = setting_to_update.schedule_pattern
      current_schedule[1] = current_schedule[0]
      setting_to_update.update_attribute(:schedule_pattern, current_schedule)
      @week_2_tiers.should_not be_valid
    end
  end

  context "3 tiers 6 teams" do
    before(:each) do
      @week_3_tiers = FactoryGirl.create(:week)
      @tier_setting = FactoryGirl.create(:tier_setting, week: @week_3_tiers, tier: 2, total_teams: 2, teams_down: 1, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)
      @tier_setting_1 = FactoryGirl.create(:tier_setting, week: @week_3_tiers, total_teams: 2,tier: 1, teams_down: 1, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)
      @tier_setting_3 = FactoryGirl.create(:tier_setting, week: @week_3_tiers, total_teams: 2,tier: 3, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)

      @teams_6 = FactoryGirl.create_list(:team, 6, league: @week_3_tiers.league)
      @teams_6.each_with_index{|team, idx|
        FactoryGirl.create(:standing, week: @week_3_tiers, team: team, rank: idx + 1)}
    end


    it "default week for 3 tiers is valid" do
      @week_3_tiers.should be_valid
    end

    it "number of teams to move up+down is more than total number of teams" do
      @week_3_tiers.tier_settings.find_by_tier(1).update_attribute(:teams_down, 2)
      @week_3_tiers.tier_settings.find_by_tier(2).update_attribute(:teams_down, 2)
      @week_3_tiers.should_not be_valid
    end

  end
end
