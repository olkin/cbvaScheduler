require 'spec_helper'

describe 'teams/show.html.erb' do

  it 'renders teams with no standings' do
    assign(:team, stub_model(Team,
                             name: 'TName',
                             captain: 'TCaptain',
                             email: 'TEmail'
    ))

    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match /TName/
    rendered.should match(/TCaptain/)
    #rendered.should match(/TEmail/)
  end


  it 'renders teams with standings'
  it 'shows emails for admins'
end
