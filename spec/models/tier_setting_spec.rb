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
  it { should respond_to(:cycle)}
  it { should respond_to(:set_points)}
  it { should respond_to(:match_times)}
  it { should respond_to(:week) }
  it { should respond_to(:tier) }
  it { should respond_to(:league) }

  it { should be_valid}

  it 'day format is invalid/missing' do
    invalid_day_formats = %w[Tuesday tues thur] + [nil]
    invalid_day_formats.each{ |invalid_value|
      @tier_setting.day = invalid_value
      expect(@tier_setting).not_to be_valid
    }
  end

  it 'tier nr is invalid/missing' do
    invalid_tier_numbers = [nil, 0, -1]
    invalid_tier_numbers.each { |invalid_tier|
      @tier_setting.tier = invalid_tier
      expect(@tier_setting).to_not be_valid
    }
  end

  it 'cycle number is invalid' do
    invalid_cycles = [-1, 0, nil]
    invalid_cycles.each do |cycle|
      @tier_setting.cycle = cycle
      @tier_setting.should_not be_valid
    end
  end

  it 'when nr of teams is invalid/missing' do
    invalid_total_teams_values = [nil, 0, 1, -1]
    invalid_total_teams_values.each{ |invalid_value|
      @tier_setting.total_teams = invalid_value
      expect(@tier_setting).not_to be_valid
    }
  end

  it 'nr of teams down is invalid/missing' do
    invalid_down_teams_values = [-1, nil, @tier_setting.total_teams + 1]
    invalid_down_teams_values.each{ |invalid_value|
      @tier_setting.teams_down = invalid_value
      expect(@tier_setting).not_to be_valid
    }
  end


  it 'schedule pattern is invalid' do
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

  it 'valid set points' do
    valid_set_points = [[23], [23,15], [15,12], [13,21,17], [16,16,16,16]]
    valid_set_points.each do |valid_data|
      @tier_setting.set_points = valid_data
      @tier_setting.should be_valid
    end
  end

  it 'set points invalid' do
    invalid_set_points = [nil, [-13], [23,-24,24]]
    invalid_set_points.each { |invalid_data|
      @tier_setting.set_points =  invalid_data
      @tier_setting.should_not be_valid
    }
  end

  it 'match times valid' do
    valid_match_times = [[10, 11, 12], ['10:00'], ['1 pm'], ['13:00']]
    valid_match_times.each { |valid_data|
      @tier_setting.match_times = valid_data
      @tier_setting.should be_valid
    }
  end

  it 'match times invalid' do
    invalid_match_times = [nil, 13]
    invalid_match_times.each { |invalid_data|
      @tier_setting.match_times =  invalid_data
      @tier_setting.should_not be_valid
    }
  end


  context '1 tier registered' do
    before {@tier_setting2 = FactoryGirl.create(:tier_setting, tier: 2, week: @tier_setting.week)}

    it 'accepts different tier nr for same league' do
      @tier_setting2.should be_valid
    end

    it 'accepts same tier for different league' do
      tier_setting3 = FactoryGirl.build(:tier_setting, tier: @tier_setting.tier)
      tier_setting3.should be_valid
    end

    it 'tier number is unique within the league' do
      @tier_setting2.tier = @tier_setting.tier
      @tier_setting2.should_not be_valid
    end
  end

end
