require "spec_helper"

describe TierSettingsController do
  describe "routing" do

    it "routes to #index" do
      get("leagues/1/tier_settings").should route_to("tier_settings#index", :league_id => "1")
    end

    it "routes to #new" do
      get("leagues/1/tier_settings/new").should route_to("tier_settings#new", :league_id => "1")
    end

    it "routes to #edit" do
      get("/tier_settings/1/edit").should route_to("tier_settings#edit", :id => "1")
    end

    it "routes to #create" do
      post("leagues/1/tier_settings").should route_to("tier_settings#create", :league_id => "1")
    end

    it "routes to #update" do
      put("/tier_settings/1").should route_to("tier_settings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tier_settings/1").should route_to("tier_settings#destroy", :id => "1")
    end

  end
end
