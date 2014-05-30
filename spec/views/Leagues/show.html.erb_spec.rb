require 'spec_helper'

describe "Leagues/show" do
  before(:each) do
    @league = assign(:league, stub_model(League, FactoryGirl.attributes_for(:league)))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Description/)
  end
end