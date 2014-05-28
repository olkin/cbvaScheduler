require 'spec_helper'

describe "league_types/edit" do
  before(:each) do
    @league_type = assign(:league_type, stub_model(LeagueType,
      :desc => "",
      :description => "MyString"
    ))
  end

  it "renders the edit league_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", league_type_path(@league_type), "post" do
      assert_select "input#league_type_desc[name=?]", "league_type[desc]"
      assert_select "input#league_type_description[name=?]", "league_type[description]"
    end
  end
end
