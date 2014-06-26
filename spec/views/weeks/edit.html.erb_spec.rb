require 'spec_helper'

describe "weeks/edit" do
  before(:each) do
    @week = assign(:week, stub_model(Week))
  end

  it "renders the edit week form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", week_path(@week), "post" do
    end
  end
end
