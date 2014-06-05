require 'spec_helper'

describe "tier_settings/edit" do
  before(:each) do
    @tier_setting = assign(:tier_setting, stub_model(TierSetting,
      :league_id => 1,
      :tier => 1,
      :total_teams => 1,
      :teams_down => 1,
      :schedule_pattern => "MyString"
    ))
  end

  it "renders the edit tier_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tier_setting_path(@tier_setting), "post" do
      assert_select "input#tier_setting_league_id[name=?]", "tier_setting[league_id]"
      assert_select "input#tier_setting_tier[name=?]", "tier_setting[tier]"
      assert_select "input#tier_setting_total_teams[name=?]", "tier_setting[total_teams]"
      assert_select "input#tier_setting_teams_down[name=?]", "tier_setting[teams_down]"
      assert_select "input#tier_setting_schedule_pattern[name=?]", "tier_setting[schedule_pattern]"
    end
  end
end
