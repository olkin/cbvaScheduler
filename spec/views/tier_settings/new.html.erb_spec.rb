require 'spec_helper'

describe "tier_settings/new" do
  let(:week) {FactoryGirl.create(:week)}
  before(:each) do
    assign(:tier_setting, stub_model(TierSetting,
      :week_id => week.to_param,
      :tier => 1,
      :total_teams => 1,
      :teams_down => 1,
      :day => "MyString",
      :schedule_pattern => "MyText"
    ).as_new_record)

    assign(:week, week)
  end

  it "renders new tier_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", week_tier_settings_path(week), "post" do
      assert_select "input#tier_setting_week_id[name=?]", "tier_setting[week_id]"
      assert_select "input#tier_setting_tier[name=?]", "tier_setting[tier]"
      assert_select "input#tier_setting_total_teams[name=?]", "tier_setting[total_teams]"
      assert_select "input#tier_setting_teams_down[name=?]", "tier_setting[teams_down]"
      assert_select "input#tier_setting_day[name=?]", "tier_setting[day]"
      assert_select "textarea#tier_setting_schedule_pattern[name=?]", "tier_setting[schedule_pattern]"
    end
  end
end
