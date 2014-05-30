require 'spec_helper'

describe "Leagues/index" do
  before(:each) do
    @leagues = assign(:Leagues, [stub_model(League, FactoryGirl.attributes_for(:league)),
      stub_model(League, FactoryGirl.attributes_for(:league)
      )
    ])
  end

  it "renders a list of Leagues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => FactoryGirl.attributes_for(:league)[:desc].to_s, :count => 2
    assert_select "tr>td", :text => FactoryGirl.attributes_for(:league)[:description].to_s, :count => 2
  end
end
