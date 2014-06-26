require 'spec_helper'

describe "weeks/index" do
  before(:each) do
    assign(:weeks, [
      stub_model(Week),
      stub_model(Week)
    ])
  end

  it "renders a list of weeks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
