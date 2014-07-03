require 'spec_helper'

describe TierSetting do
  before(:each) do
    @tier_setting = FactoryGirl.build(:tier_setting)
  end

  subject { @tier_setting }

  it { should respond_to(:schedule_pattern) }
  it { should respond_to(:day) }
  it { should respond_to(:total_teams) }
  it { should respond_to(:teams_down) }

  it "has valid factory" do
    @tier_setting.valid?
    puts "New test" + @tier_setting.errors.to_s
    expect(@tier_setting.valid?).to be_true
  end

  context "is invalid" do

    it "when nr of teams is invalid/missing" do
      invalid_total_teams_values = [nil, 0, 1, -1, 1.5, "5"]
      invalid_total_teams_values.each{ |invalid_value|
        @tier_setting.total_teams = invalid_value
        expect(@tier_setting.valid?).to be_false
      }
    end

    it "when nr of teams down is invalid/missing" do
      invalid_down_teams_values = [-1, 1.5, "5"]
      invalid_down_teams_values.each{ |invalid_value|
        @tier_setting.teams_down = invalid_value
        expect(@tier_setting.valid?).to be_false
      }
    end

    it "when day is format is invalid/missing" do
      invalid_day_formats = %w[Tuesday tues thur] + [nil]
      invalid_day_formats.each{ |invalid_value|
        @tier_setting.day = invalid_value
        expect(@tier_setting.valid?).to be_false
      }
    end

    it "when teams down is more than total teams is invalid" do
      @tier_setting.total_teams = 2
      @tier_setting.teams_down = 3
      expect(@tier_setting.valid?).to be_false
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
        expect(tier_setting.valid?).to be_false
      }
    end


  end

end
