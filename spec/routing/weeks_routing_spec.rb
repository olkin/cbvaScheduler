require "spec_helper"

describe WeeksController do
  describe "routing" do

    it "routes to #index" do
      get("leagues/1/settings").should route_to("weeks#index", league_id: "1")
    end

    it "routes to #new_tier" do
      get("/leagues/1/settings/new_tier").should route_to("weeks#new_tier", league_id: "1")
    end

    it "routes to #create_tier" do
      post("/leagues/1/settings/create_tier").should route_to("weeks#create_tier", league_id: "1")
    end

    it "routes to #edit_tier" do
      get("/leagues/1/settings/edit_tier").should route_to("weeks#edit_tier", league_id: "1")
    end

    it "routes to #update_tier" do
      put("/leagues/1/settings/update_tier").should route_to("weeks#update_tier", league_id: "1")
    end

    it "routes to #destroy_tier" do
      delete("/leagues/1/settings/destroy_tier").should route_to("weeks#destroy_tier", league_id: "1")
    end

  end
end
