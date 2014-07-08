require "spec_helper"

describe TierSettingsController do
  describe "routing" do
    it "routes to #index" do
      get("/settings/2/tier_settings").should route_to("tier_settings#index", week_id: "2")
    end

    it "routes to #new" do
      get("/settings/2/tier_settings/new").should route_to("tier_settings#new", week_id: "2")
    end

    it "routes to #show" do
      get("/tier_settings/3").should route_to("tier_settings#show", :id => "3")
    end

    it "routes to #edit" do
      get("/tier_settings/2/edit").should route_to("tier_settings#edit", id: "2")
    end

    it "routes to #create" do
      post("/settings/2/tier_settings").should route_to("tier_settings#create", week_id: "2")
    end

    it "routes to #update" do
      put("/tier_settings/3").should route_to("tier_settings#update", id: "3")
    end

    it "routes to #destroy" do
      delete("/tier_settings/3").should route_to("tier_settings#destroy", id: "3")
    end

  end
end
