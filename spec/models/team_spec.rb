require 'spec_helper'

describe Team do
  before { @team = FactoryGirl.create(:team) }

  subject { @team }

  it { should respond_to(:name) }
  it { should respond_to(:captain) }
  it { should respond_to(:email) }
  it { should respond_to(:league) }
  it { should respond_to(:league_id) }
  it { should respond_to(:short_name) }
  its(:league) { should eq @team.league }

  it { should be_valid }

  it 'has invalid name' do
    invalid_names = [nil, '', '  ']
    invalid_names.each { |name|
      @team.name = name
      @team.should_not be_valid
    }
  end


  it 'captain\'s name is invalid' do
    invalid_names = [nil, '', '  ']
    invalid_names.each { |name|
      @team.captain = name
      @team.should_not be_valid
    }
  end

  it 'valid emails' do
    valid_emails = [nil, '', ' ',] + %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    valid_emails.each do |valid_email|
      @team.email = valid_email
      expect(@team).to be_valid
    end
  end

  it 'invalid emails' do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                   foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |invalid_address|
      @team.email = invalid_address
      expect(@team).not_to be_valid
    end
  end

  it 'has valid league associated' do
    @team.league_id = nil
    @team.should_not be_valid

  end

  it 'league should destroy associated teams' do
    teams = @team.league.teams.all.to_a
    @team.league.destroy
    expect(teams).not_to be_empty
    teams.each do |team|
      expect(Team.where(id: team.id)).to be_empty
    end
  end

  context 'more than 1 teams registered in the league' do
    before { @team2 = FactoryGirl.create(:team, league: @team.league) }

    it 'can register 2nd team' do
      @team2.should be_valid
    end

    it 'has unique team names within league' do
      @team2.name = @team.name
      @team2.should_not be_valid
    end
  end

  it 'can have same team names within different leagues' do
    team3 = FactoryGirl.create(:team, name: @team.name)
    team3.should be_valid
  end

  it 'has a short name' do
    @team.name = 'Very very very very very very very very very very long name'
    (@team.short_name.size <= 20).should be_true
  end

end
