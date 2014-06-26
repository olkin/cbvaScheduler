require 'spec_helper'

describe "weeks/show" do
  before(:each) do
    @week = assign(:week, stub_model(Week))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
