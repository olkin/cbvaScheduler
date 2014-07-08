require 'spec_helper'

describe "weeks/edit" do
  before(:each) do
    league = FactoryGirl.create(:league)
    @week = assign(:week, stub_model(Week, league_id: league.to_param))
  end

  it "renders the edit week form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", week_path(@week), "post" do
    end
  end
end
