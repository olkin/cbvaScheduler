require 'spec_helper'

describe "tier_settings/show" do
  let(:week) {FactoryGirl.create(:week, id: 1)}

  before(:each) do
    assign(:tier_setting, stub_model(TierSetting,
      :week_id => 1,
      :tier => 2,
      :total_teams => 3,
      :teams_down => 4,
      :day => "Day",
      :schedule_pattern => "MyText"
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
    rendered.should match(/Day/)
    rendered.should match(/MyText/)
  end
end
