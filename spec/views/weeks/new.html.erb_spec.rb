require 'spec_helper'

describe "weeks/new" do
  let (:league) {FactoryGirl.create(:league)}
  before(:each) do
    assign(:week, stub_model(Week, league_id: league.to_param).as_new_record)
    assign(:league, league)
  end

  it "renders new week form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", league_weeks_path(league), "post" do
    end
  end
end
