require 'spec_helper'

describe "teams/new" do
  let(:league) {FactoryGirl.create(:league)}

  before(:each) do
    assign(:team, stub_model(Team,
      :name => "MyString",
      :captain => "MyString",
      :email => "MyString",
      :league_id => league.id
    ).as_new_record)
    assign(:league, league)
  end

  it "renders new team form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", league_teams_path(league), "post" do
      assert_select "input#team_name[name=?]", "team[name]"
      assert_select "input#team_captain[name=?]", "team[captain]"
      assert_select "input#team_email[name=?]", "team[email]"
    end
  end
end
