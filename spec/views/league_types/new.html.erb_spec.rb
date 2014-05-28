require 'spec_helper'

describe "league_types/new" do
  before(:each) do
    assign(:league_type, stub_model(LeagueType,
      :desc => "",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new league_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", league_types_path, "post" do
      assert_select "input#league_type_desc[name=?]", "league_type[desc]"
      assert_select "input#league_type_description[name=?]", "league_type[description]"
    end
  end
end
