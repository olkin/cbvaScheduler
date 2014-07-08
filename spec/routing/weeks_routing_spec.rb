require "spec_helper"

describe WeeksController do
  describe "routing" do

    it "routes to #index" do
      get("leagues/1/settings").should route_to("weeks#index", league_id: "1")
    end

    it "routes to #new" do
      get("/leagues/2/settings/new").should route_to("weeks#new", league_id: "2")
    end


    it "routes to #show" do
      get("/settings/2").should route_to("weeks#show", id: "2")
    end

    it "routes to #edit" do
      get("/settings/2/edit").should route_to("weeks#edit", id: "2")
    end

    it "routes to #create" do
      post("/leagues/1/settings").should route_to("weeks#create", league_id: "1")
    end

    it "routes to #update" do
      put("/settings/3").should route_to("weeks#update", id: "3")
    end

    it "routes to #destroy" do
      delete("/settings/3").should route_to("weeks#destroy", id: "3")
    end
  end
end
