require 'spec_helper'

describe "tier_settings/index" do
  before(:each) do
    assign(:tier_settings, [
      stub_model(TierSetting,
        :week_id => 1,
        :tier => 2,
        :total_teams => 3,
        :teams_down => 4,
        :day => "Day",
        :schedule_pattern => "MyText"
      ),
      stub_model(TierSetting,
        :week_id => 1,
        :tier => 2,
        :total_teams => 3,
        :teams_down => 4,
        :day => "Day",
        :schedule_pattern => "MyText"
      )
    ])
  end

  it "renders a list of tier_settings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Day".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
