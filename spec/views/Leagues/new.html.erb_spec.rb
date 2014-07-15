require 'spec_helper'

describe "leagues/new" do
  before(:each) do
    assign(:league, stub_model(League, FactoryGirl.attributes_for(:league)
    ).as_new_record)
  end

  it "renders new league form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", leagues_path, "post" do
      assert_select "input#league_desc[name=?]", "league[desc]"
      assert_select "input#league_description[name=?]", "league[description]"
    end
  end
end
