require 'spec_helper'

describe "league_types/index" do
  before(:each) do
    assign(:league_types, [
      stub_model(LeagueType,
        :desc => "",
        :description => "Description"
      ),
      stub_model(LeagueType,
        :desc => "",
        :description => "Description"
      )
    ])
  end

  it "renders a list of league_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
