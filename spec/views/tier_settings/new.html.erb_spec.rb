require 'spec_helper'

describe "tier_settings/new" do
  before(:each) do
    assign(:tier_setting, stub_model(TierSetting,
      :league_id => 1,
      :tier => 1,
      :total_teams => 1,
      :teams_down => 1,
      :schedule_pattern => "MyString"
    ).as_new_record)
  end

  it "renders new tier_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tier_settings_path, "post" do
      assert_select "input#tier_setting_league_id[name=?]", "tier_setting[league_id]"
      assert_select "input#tier_setting_tier[name=?]", "tier_setting[tier]"
      assert_select "input#tier_setting_total_teams[name=?]", "tier_setting[total_teams]"
      assert_select "input#tier_setting_teams_down[name=?]", "tier_setting[teams_down]"
      assert_select "input#tier_setting_schedule_pattern[name=?]", "tier_setting[schedule_pattern]"
    end
  end
end
