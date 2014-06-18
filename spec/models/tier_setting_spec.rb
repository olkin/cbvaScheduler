require 'spec_helper'

describe TierSetting do
  before(:each) do
    @tier_setting = FactoryGirl.create(:tier_setting)
  end

  subject { @tier_setting }

  it { should respond_to(:tier) }
  it { should respond_to(:schedule_pattern) }
  it { should respond_to(:day) }
  it { should respond_to(:league) }
  it { should respond_to(:league_id) }
  it { should respond_to(:total_teams) }
  it { should respond_to(:teams_down) }
  its(:league) { should eq @tier_setting.league }

  it { should be_valid }

  describe "when tier is not present" do
    before { @tier_setting.tier = nil }
    it { should_not be_valid }
  end

  describe "when tier nr is invalid" do
    before { @tier_setting.tier = 0 }
    it { should_not be_valid }
  end

  describe "when nr of teams is missing" do
    before { @tier_setting.total_teams = 0 }
    it { should_not be_valid }
  end

  describe "when nr of teams is invalid" do
    before { @tier_setting.total_teams = 1 }
    it { should_not be_valid }
  end

  describe "when teams down is missing" do
    before { @tier_setting.teams_down = -1 }
    it { should_not be_valid }
  end

  describe "when teams down is more than total teams is invalid" do
    before {
      @tier_setting.total_teams = 2
      @tier_setting.teams_down = 3
    }
    it { should_not be_valid }
  end

  describe "when day is missing" do
    before { @tier_setting.day = nil }
    it { should_not be_valid }
  end

  describe "when day format is invalid" do
    it "should be invalid" do
      day_formats = %w[Tuesday tues thur]
      day_formats.each do |invalid_day|
        #@tier_setting.day = invalid_day
        @tier_setting.day = invalid_day
        expect(@tier_setting).not_to be_valid
      end
    end
  end

  describe "when league_id is not present" do
    before { @tier_setting.league_id = nil }
    it { should_not be_valid }
  end

  it "should destroy associated settings" do
    tier_settings = @tier_setting.league.tier_settings.to_a
    @tier_setting.league.destroy
    expect(tier_settings).not_to be_empty
    tier_settings.each do |tier_settings|
      expect(Team.where(id: tier_settings.id)).to be_empty
    end
  end

  describe "when tier nr already exists" do
    it "doesn't accept another setting for same tier" do
      tier_settings2 = @tier_setting.dup
      tier_settings2.save
      tier_settings2.should_not be_valid
    end

    it "accepts a setting for tier nrfor different league" do
      tier_settings2 = @tier_setting.dup
      league2 = @tier_setting.league.dup
      league2.desc = "Another name"
      league2.save

      tier_settings2.league_id = league2.id
      tier_settings2.should be_valid
    end
  end

  it "when schedule pattern is invalid" do
    invalid_formats = ["","[]","[[]]",
                       "[[[1,2,3]],[[1,2,3]]]",
                       "[[[1,3,3]],[[1,2,3]]]",
                       "[[[1,2,3],[1,2,4],[[1,2,3]],[[1,2,3]]]]",
                       "[[[1,2,3],[1,2,3],[[1,2,3]],[[1,2,3]]]]",
                       "[[[1,2,13],[[1,2,3]],[[1,2,3]]]]",
                       "[[[1,2,3],[[]],[[1,2,3]]]]",
                       "[[[1,2,3],[],[[1,2,3]]]]",
                       "[[[1,2,3],1,[[1,2,3]]]]",
                       "[[[1,2,3],nil,[[1,2,3]]]]"

    ]

    invalid_formats.each {|invalid_schedule|
      FactoryGirl.build(:tier_setting, league: @tier_setting.league, schedule_pattern: invalid_schedule, total_teams: 2, tier: 2).should_not be_valid
    }
  end

end
