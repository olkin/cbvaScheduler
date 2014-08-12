require 'spec_helper'

describe 'teams/index' do
 let(:league) {FactoryGirl.create(:league)}

  before(:each) do
    assign(:teams, [
      stub_model(Team,
        :name => 'Name',
        :captain => 'Captain',
        :email => 'Email',
        :league_id => league.id
      ),
      stub_model(Team,
        :name => 'Name',
        :captain => 'Captain',
        :email => 'Email',
        :league_id => league.id
      )
    ])

    assign(:league, league)
  end

  it 'renders a list of teams' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'tr>td', :text => 'Name'.to_s, :count => 2
    assert_select 'tr>td', :text => 'Captain'.to_s, :count => 2
    assert_select 'tr>td', :text => 'Email'.to_s, :count => 0
  end

  pending 'render for admin - should show email'


end
