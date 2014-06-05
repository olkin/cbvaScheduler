require 'spec_helper'

describe "tier_settings/show" do
  before(:each) do
    @tier_setting = assign(:tier_setting, stub_model(TierSetting,
      :league_id => 1,
      :tier => 2,
      :total_teams => 3,
      :teams_down => 4,
      :schedule_pattern => "Schedule Pattern"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/Schedule Pattern/)
  end
end
