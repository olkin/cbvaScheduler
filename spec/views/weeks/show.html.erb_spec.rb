require 'spec_helper'

describe 'weeks/show.html.erb' do

  it 'renders matches for non-setting week' do
    @league = FactoryGirl.create(:league, description: 'League#7')
    assign(:week, stub_model(Week,
                             :league_id => @league.id,
                             :week => nil
    ))

    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match /League#7/
    rendered.should match(/Tier Settings/)
    rendered.should match(/Standings/)
  end


  it 'renders matches for non-setting week' do
    @league = FactoryGirl.create(:league, id: 1, description: 'League#7')
    assign(:week, stub_model(Week,
                             :league_id => 1,
                             :week => 1
    ))

    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match /League#7/
    rendered.should match(/Matches/)
  end
end
