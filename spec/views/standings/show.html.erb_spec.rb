require 'spec_helper'

describe "standings/show" do
  let(:week) {FactoryGirl.create(:week, id: 1)}
  let(:team) {FactoryGirl.create(:team, league: week.league, id:2)}

  before(:each) do
    assign(:standing, stub_model(Standing,
                                 :week_id => week.to_param,
                                 :team_id => team.id,
                                 :rank => 3,
                                 :tier => 4
    ))
    assign(:week, week)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
  end
end
