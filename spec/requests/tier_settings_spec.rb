require 'spec_helper'

describe "TierSettings" do
  let(:league) {FactoryGirl.create(:league)}
  describe "GET /tier_settings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get league_tier_settings_path(league)
      response.status.should be(200)
    end
  end
end
