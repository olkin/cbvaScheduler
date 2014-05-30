require 'spec_helper'

describe "Leagues/edit" do
  before(:each) do
    @league = assign(:league, stub_model(League,
      FactoryGirl.attributes_for(:league)
    ))
  end

  it "renders the edit league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", league_path(@league), "post" do
      assert_select "input#league_desc[name=?]", "league[desc]"
      assert_select "input#league_description[name=?]", "league[description]"
    end
  end
end
