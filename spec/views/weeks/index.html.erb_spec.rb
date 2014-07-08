require 'spec_helper'

describe "weeks/index" do
  let(:league) {FactoryGirl.create(:league)}
  before(:each) do
    assign(:weeks, [
      stub_model(Week, league: league),
      stub_model(Week, league: league)
    ])

    assign(:league, league)
  end

  it "renders a list of weeks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
