require 'spec_helper'

describe TierSetting do
  before(:each) do
    @tier_setting = FactoryGirl.create(:tier_setting)
  end

  subject { @tier_setting }

  it { should respond_to(:schedule_pattern) }
  it { should respond_to(:day) }
  it { should respond_to(:total_teams) }
  it { should respond_to(:teams_down) }
  it { should respond_to(:tier) }

  it "has valid factory" do
    expect(@tier_setting).to be_valid
  end

  it "accepts same tier for different league" do
    tier_setting2 = FactoryGirl.build(:tier_setting)
    expect(tier_setting2).to be_valid
  end

  it "accepts different tier nr for same league" do
    tier_setting2 = FactoryGirl.build(:tier_setting, tier: 2, week: @tier_setting.week)
    expect(tier_setting2).to be_valid
  end

  it "can have unspecified cycle" do
    @tier_setting.cycle = nil
    @tier_setting.should be_valid
  end

  it "cannot have negative cycle" do
    @tier_setting.cycle = -1
    @tier_setting.should_not be_valid
  end


  context "is invalid" do
    it "when tier nr is invalid/missing" do
      invalid_tier_numbers = [nil, 0, -1]
      invalid_tier_numbers.each { |invalid_tier|
        @tier_setting.tier = invalid_tier
        expect(@tier_setting).to_not be_valid
      }
    end

    it "when tier number is duplicated" do
      tier_setting2 = FactoryGirl.build(:tier_setting, week: @tier_setting.week)
      expect(tier_setting2).not_to be_valid
    end

    it "when nr of teams is invalid/missing" do
      invalid_total_teams_values = [nil, 0, 1, -1]
      invalid_total_teams_values.each{ |invalid_value|
        @tier_setting.total_teams = invalid_value
        expect(@tier_setting).not_to be_valid
      }
    end

    it "when nr of teams down is invalid/missing" do
      invalid_down_teams_values = [-1, nil]
      invalid_down_teams_values.each{ |invalid_value|
        @tier_setting.teams_down = invalid_value
        expect(@tier_setting).not_to be_valid
      }
    end

    it "when day is format is invalid/missing" do
      invalid_day_formats = %w[Tuesday tues thur] + [nil]
      invalid_day_formats.each{ |invalid_value|
        @tier_setting.day = invalid_value
        expect(@tier_setting).not_to be_valid
      }
    end

    it "when teams down is more than total teams is invalid" do
      @tier_setting.total_teams = 2
      @tier_setting.teams_down = 3
      expect(@tier_setting).not_to be_valid
    end

    it "when schedule pattern is invalid" do
      invalid_formats = [nil,[],[[]],
                         [[[1,2,3]],[[1,2,3]]],
                         [[[1,3,3]],[[1,2,3]]],
                         [[[1,2,3],[1,2,4],[[1,2,3]],[[1,2,3]]]],
                         [[[1,2,3],[1,2,3],[[1,2,3]],[[1,2,3]]]],
                         [[[1,2,13],[[1,2,3]],[[1,2,3]]]],
                         [[[1,2,3],[[]],[[1,2,3]]]],
                         [[[1,2,3],[],[[1,2,3]]]],
                         [[[1,2,3],1,[[1,2,3]]]],
                         [[[1,2,3],nil,[[1,2,3]]]]

      ]

      invalid_formats.each {|invalid_schedule|
        tier_setting = FactoryGirl.build(:tier_setting,  schedule_pattern: invalid_schedule, total_teams: 2)
        expect(tier_setting).not_to be_valid
      }
    end


  end

end
