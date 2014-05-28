require 'spec_helper'

describe "league_types/show" do
  before(:each) do
    @league_type = assign(:league_type, stub_model(LeagueType,
      :desc => "",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Description/)
  end
end
