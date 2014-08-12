require 'spec_helper'

describe Week do

  before { @week = FactoryGirl.create(:week) }

  subject { @week }
  it { should be_valid }
  it { should respond_to(:week) }
  it { should respond_to(:league)}

  it 'with invalid format' do
    @week.week = -1
    @week.should_not be_valid
  end

  it 'can have several week for same league' do
    week2 = FactoryGirl.create(:week, week: @week.week || 1, league: @week.league)
    week2.should be_valid
  end

  it 'unique week nr for same league' do
    week2 = FactoryGirl.build(:week, league: @week.league, week: @week.week)
    week2.should_not be_valid
  end

  it 'calculates next missing tier' do
    @week.next_missing_tier.should eql 1
  end

  it 'league should destroy associated weeks' do
    weeks = @week.league.weeks.all.to_a
    @week.league.destroy
    expect(weeks).not_to be_empty
    weeks.each do |week|
      expect(Week.where(id: week.id)).to be_empty
    end
  end

  it 'default week is a setting week' do
    @week.setting?.should be_true
  end


  it '# week is a not setting week' do
    @week.week = 1
    @week.setting?.should be_false
  end


  it 'has matches associated' do
    @week.matches.should be_empty

    tier_setting = FactoryGirl.create(:tier_setting)
    match = FactoryGirl.create(:match, week: tier_setting.week)

    tier_setting2 = FactoryGirl.create(:tier_setting)
    FactoryGirl.create(:match, week: tier_setting2.week)
    match.week.matches.should_not be_empty
    match.week.matches.size.should eql 1
  end

  it 'has tier settings associated' do
    @week.tier_settings.should be_empty

    FactoryGirl.create(:tier_setting, week: @week)
    FactoryGirl.create(:tier_setting)
    @week.tier_settings(true).should_not be_empty
    @week.tier_settings.size.should eql 1
  end

  context '1 tier 2 teams:' do
    before do
      FactoryGirl.create(:tier_setting, week: @week, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)

      FactoryGirl.create_list(:team, 2, league: @week.league).each_with_index{|team, idx|
        FactoryGirl.create(:standing, week: @week, team: team, rank: idx + 1)
      }
    end

    it { should be_valid }


    it 'calculates next missing tier' do
      @week.next_missing_tier.should eql 2
    end

    it 'number of registered teams should not be less of teams in tiers ' do
      @week.standings.last.destroy
      @week.should_not be_valid
    end

    it 'number of registered teams should not be more of teams in tiers ' do
      team3 = FactoryGirl.create(:team, league: @week.league)
      FactoryGirl.create(:standing, week: @week, team: team3, rank: 3)
      @week.should_not be_valid
    end

    it 'settings for a tier should not be missing' do
      @week.tier_settings(true).first.update_attribute(:tier, 2) # knowing we have only 1 tier setting
      @week.should_not be_valid
    end

    it 'when rank is > than number of teams for league' do
      @week.standings.last.update_attribute(:rank, 3)
      @week.should_not be_valid
    end

  end


  context '2 tiers 4 teams:' do
    before do
      FactoryGirl.create(:tier_setting, week: @week, tier: 2, total_teams: 2, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)
      FactoryGirl.create(:tier_setting, week: @week, total_teams: 2,tier: 1, teams_down: 1, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)

      FactoryGirl.create_list(:team, 4, league: @week.league).each_with_index{|team, idx|
        FactoryGirl.create(:standing, week: @week, team: team, rank: idx + 1)}
    end

    it {should be_valid}


    it 'doesn\'t accept number of up as 0' do
      @week.tier_settings.find_by_tier(1).update_attribute(:teams_down, 0)
      @week.should_not be_valid
    end

    it 'doesn\'t allow different number of cycles in tiers' do
      setting_to_update = @week.tier_settings.find_by_tier(1)
      current_schedule = setting_to_update.schedule_pattern
      current_schedule[1] = current_schedule[0]
      setting_to_update.update_attribute(:schedule_pattern, current_schedule)
      @week.should_not be_valid
    end

  end

  context '3 tiers 6 teams' do
    before do
      FactoryGirl.create(:tier_setting, week: @week, tier: 2, total_teams: 2, teams_down: 1, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)
      FactoryGirl.create(:tier_setting, week: @week, total_teams: 2,tier: 1, teams_down: 1, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)
      FactoryGirl.create(:tier_setting, week: @week, total_teams: 2,tier: 3, teams_down: 0, schedule_pattern: League::DEFAULT_SCHEDULE_PATTERNS[2].dup)

      FactoryGirl.create_list(:team, 6, league: @week.league).each_with_index{|team, idx|
        FactoryGirl.create(:standing, week: @week, team: team, rank: idx + 1)}
    end

    it { should be_valid }

    it 'number of teams to move up+down is more than total number of teams' do
      @week.tier_settings.find_by_tier(1).update_attribute(:teams_down, 2)
      @week.tier_settings.find_by_tier(2).update_attribute(:teams_down, 2)
      @week.should_not be_valid
    end

  end

end
