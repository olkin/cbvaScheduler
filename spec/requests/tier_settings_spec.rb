require 'spec_helper'

describe "TierSettings" do
  describe "GET /tier_settings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tier_settings_path
      response.status.should be(200)
    end
  end
end
