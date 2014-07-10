require 'spec_helper'

describe "standings/edit" do
  let(:week) {FactoryGirl.create(:week)}
  let(:team) {FactoryGirl.create(:team, league: week.league)}

  before(:each) do
    @standing = assign(:standing, stub_model(Standing,
      :week_id => week.to_param,
      :team_id => team.to_param,
      :rank => 1,
      :tier => 1
    ))
  end

  it "renders the edit tier_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", standing_path(@standing), "post" do
      assert_select "input#standing_tier[name=?]", "standing[tier]"
      assert_select "input#standing_rank[name=?]", "standing[rank]"
   #   assert_select "input#standing_team_id[name=?]", "standing[team_id]"
    end
  end
end
