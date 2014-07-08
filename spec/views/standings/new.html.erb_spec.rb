require 'spec_helper'

describe "standings/new" do
  let(:week) {FactoryGirl.create(:week)}
  let(:team) {FactoryGirl.create(:team, league: week.league)}

  before(:each) do
    assign(:standing, stub_model(Standing,
                                     :week_id => week.to_param,
                                     :team_id => team.to_param,
                                     :rank => 1,
                                     :tier => 1
    ).as_new_record)

    assign(:week, week)
  end

  it "renders new standing form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", week_standings_path(week), "post" do
      assert_select "input#standing_week_id[name=?]", "standing[week_id]"
      assert_select "input#standing_tier[name=?]", "standing[tier]"
      assert_select "input#standing_rank[name=?]", "standing[rank]"
      assert_select "input#standing_team_id[name=?]", "standing[team_id]"
    end
  end
end
