require 'spec_helper'

describe 'standings/show' do

  before {
    @team = FactoryGirl.create(:team, name: 'Name', captain: 'Cap', email: 'me@email.com')
    @week = FactoryGirl.create(:week, league: @team.league)
    @standing = FactoryGirl.create(:standing, team: @team, week: @week)

    assign(:standing, stub_model(Standing,
                                 :id => @standing.id,
                                 :week_id => @week.id,
                                 :team_id => @team.id,
                                 :rank => 3,
                                 :tier => 4
    ))
  }

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Cap/)
    #rendered.should match(/me@email.com/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/Schedule is not ready/)
  end

  it 'shows results of games' do
    team2 = FactoryGirl.create(:team, league: @team.league, name: 'team2')
    standing2 = FactoryGirl.create(:standing, week: @week, team: team2, rank: @standing.rank + 1)
    FactoryGirl.create(:tier_setting, week: @week, match_times: ['10:00'])
    FactoryGirl.create(:match, standing1: standing2, standing2: @standing, score: [[21,15]], court: 3, game: 1)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Results\/Schedule/)
    rendered.should match(/team2/)
    rendered.should match(/3/)
    rendered.should match(/15:21/)
    rendered.should match(/0\/1/)
    rendered.should match(/-6/)
    rendered.should match(/Total/)
    rendered.should match(/10:00/)
  end
end
