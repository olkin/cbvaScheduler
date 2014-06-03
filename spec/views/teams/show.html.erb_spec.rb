require 'spec_helper'

describe "teams/show" do
  let(:league) {FactoryGirl.create(:league)}

  before(:each) do
    @team = assign(:team, stub_model(Team,
      :name => "Name",
      :captain => "Captain",
      :email => "Email",
      :league_id => league.id
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Captain/)
    rendered.should match(/Email/)
  end
end
