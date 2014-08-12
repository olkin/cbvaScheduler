require 'spec_helper'

describe League do
  before do
    @league = FactoryGirl.create(:league)
  end

  it { @league.should respond_to(:desc) }
  it { @league.should respond_to(:description) }
  it { @league.should respond_to(:start_date)}
  it { @league.should respond_to(:teams) }
  it { @league.should respond_to(:weeks) }

  it {@league.should be_valid}

  it 'should have valid abbreviation' do
    invalid_abbrvs = [nil, '', ' ']
    invalid_abbrvs.each{ |abbr|
      @league.desc = abbr
      @league.should_not be_valid
    }
  end


  it 'should have valid description' do
    invalid_descriptions = [nil, '', ' ']
    invalid_descriptions.each{ |description|
      @league.description = description
      @league.should_not be_valid
    }
  end

  it 'no teams associated on creation' do
    @league.teams.should be_empty
  end

  it 'no weeks associated on creation' do
    @league.weeks.should be_empty
  end

  context 'more than 1 league exists' do
    before do
      @league2 = FactoryGirl.create(:league)
    end

    it '2nd league is valid' do
      @league2.should be_valid
    end

    it 'description is unique' do
      @league2.description = @league.description
      @league2.should_not be_valid
    end

    it 'desc is unique' do
      @league2.desc = @league.desc
      @league2.should_not be_valid
    end
  end

  context 'has teams registered' do
    before do
      @team = FactoryGirl.create(:team, league: @league)
    end

    it 'should have teams associated' do
      @league.teams.should_not be_empty
    end
  end

  it 'shows nil for cur_week' do
    @league.cur_week.should be nil
  end

  context 'has weeks set up' do
    before do
      @week = FactoryGirl.create(:week, league: @league)
    end

    it 'should have teams associated' do
      @league.weeks.should_not be_empty
    end

    it 'shows cur week' do
      @league.cur_week.should eql @week
    end
  end

end
