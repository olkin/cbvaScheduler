require 'spec_helper'

describe "Leagues" do

  subject { page }

  describe "GET /Leagues" do
    it "works!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get leagues_path
      response.status.should be(200)
    end
  end

  describe "league page" do
    let(:league) { FactoryGirl.create(:league) }
    before { visit league_path(league) }

    it { should have_content(league.description) }
    it { should have_title(league.description) }
    it { should have_content("Registration is not finished")}
  end


end
