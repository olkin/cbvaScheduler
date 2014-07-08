require 'spec_helper'

describe "standings/index" do
  let(:week) {FactoryGirl.create(:week, id: 1)}
  let(:team) {FactoryGirl.create(:team, league: week.league, name: "Random")}
  before(:each) do

    assign(:standings, [stub_model(Standing,
                                 :week_id => week.to_param,
                                 :team_id => team.id,
                                 :rank => 3,
                                 :tier => 4
                        ),
                        stub_model(Standing,
                                   :week_id => week.to_param,
                                   :team_id => team.id,
                                   :rank => 3,
                                   :tier => 4
                        )
    ])

    assign(:week, week)
  end

  it "renders a list of tier_settings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Random", :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
