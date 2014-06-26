require 'spec_helper'

describe "weeks/new" do
  before(:each) do
    assign(:week, stub_model(Week).as_new_record)
  end

  it "renders new week form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", weeks_path, "post" do
    end
  end
end
