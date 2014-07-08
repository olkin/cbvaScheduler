require 'spec_helper'

describe "weeks/show.html.erb" do
  let(:league) {FactoryGirl.create(:league, id: 1)}

  before(:each) do
    assign(:week, stub_model(Week,
                                     :league_id => league.id,
                                     :week => 2,
                                     :cycle => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
