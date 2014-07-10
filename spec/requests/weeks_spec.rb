require 'spec_helper'

describe "Weeks" do
  let(:league) {FactoryGirl.create(:league)}
  describe "GET /weeks" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get league_weeks_path(league)
      response.status.should be(302)
    end
  end
end
