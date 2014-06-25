require 'spec_helper'

describe "Leagues/index" do
  before(:each) do
    @leagues = assign(:Leagues,
                      [stub_model(League, desc: "L", description: "League"),
      stub_model(League, desc: "L", description: "League"
      )
    ])
  end

  it "renders a list of Leagues" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "L", :count => 2
    assert_select "tr>td", :text => "League", :count => 2
  end
end
