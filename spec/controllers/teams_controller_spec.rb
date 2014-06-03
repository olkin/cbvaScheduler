require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe TeamsController do

  let(:league) {FactoryGirl.create(:league)}
  let(:valid_attributes) {FactoryGirl.attributes_for(:team).merge(:league_id=>league.id)}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TeamsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "when team is created" do
    before(:each) do
      @team = FactoryGirl.create(:team, league: league)
    end

    describe "GET index" do
      it "assigns all teams as @teams" do
        get :index, {}, valid_session
        assigns(:teams).should eq([@team])
      end
    end

    describe "GET show" do
      it "assigns the requested team as @team" do
        get :show, {:id => @team.to_param}, valid_session
        assigns(:team).should eq(@team)
      end
    end

    describe "GET edit" do
      it "assigns the requested team as @team" do
        get :edit, {:id => @team.to_param}, valid_session
        assigns(:team).should eq(@team)
      end
    end


    it "re-renders the 'edit' template" do
      # Trigger the behavior that occurs when invalid params are submitted
      Team.any_instance.stub(:save).and_return(false)
      put :update, {:id => @team.to_param, :team => { "name" => "invalid value" }}, valid_session
      response.should render_template("edit")
    end

    describe "DELETE destroy" do
      it "destroys the requested team" do
        expect {
          delete :destroy, {:id => @team.to_param}, valid_session
        }.to change(Team, :count).by(-1)
      end

      it "redirects to the league teams list" do
        delete :destroy, {:id => @team.to_param}, valid_session
        response.should redirect_to(league_url)
      end
    end


    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested team" do
          # Assuming there are no other teams in the database, this
          # specifies that the Team created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Team.any_instance.should_receive(:update).with({ "name" => "MyString" })
          put :update, {:id => @team.to_param, :team => { "name" => "MyString" }}, valid_session
        end

        it "assigns the requested team as @team" do
          put :update, {:id => @team.to_param, :team => { "name" => "MyString" }}, valid_session
          assigns(:team).should eq(@team)
        end

        it "redirects to the team" do
          put :update, {:id => @team.to_param, :team => { "name" => "MyString" }}, valid_session
          response.should redirect_to(@team)
        end
      end

      describe "with invalid params" do
        it "assigns the team as @team" do
          # Trigger the behavior that occurs when invalid params are submitted
          Team.any_instance.stub(:save).and_return(false)
          put :update, {:id => @team.to_param, :team => { "name" => "invalid value" }}, valid_session
          assigns(:team).should eq(@team)
        end
      end
    end
  end

  describe "GET new" do
    it "assigns a new team as @team" do
      get :new, {league_id: league.id}, valid_session
      assigns(:team).should be_a_new(Team)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes, league_id: league.id}, valid_session
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes, league_id: league.id}, valid_session
        assigns(:team).should be_a(Team)
        assigns(:team).should be_persisted
      end

      it "redirects to the league team list" do
        post :create, {:team => valid_attributes, league_id: league.id}, valid_session
        response.should redirect_to(league_url(league))
        #notice: 'Team was successfully created.'
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved team as @team" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => { "name" => "invalid value" }, league_id: league.id}, valid_session
        assigns(:team).should be_a_new(Team)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Team.any_instance.stub(:save).and_return(false)
        post :create, {:team => { "name" => "invalid value"}, league_id: league.id}, valid_session
        response.should render_template("new")
      end
    end
  end

end
