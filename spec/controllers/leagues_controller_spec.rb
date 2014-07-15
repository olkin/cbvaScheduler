require 'spec_helper'

describe LeaguesController do

  context "with valid attributes" do

    let (:league) {League.create!(FactoryGirl.attributes_for(:league))}

    describe "GET new" do
      it "assigns a new league as league" do
        get :new
        assigns(:league).should be_a_new(League)
      end
    end

    describe "GET index" do
      it "assigns all leagues as leagues" do
        get :index, {}
        assigns(:leagues).should eq([league])
      end
    end

    describe "GET show" do
      it "assigns the requested league as @league" do
        get :show, {:id => league.to_param}
        assigns(:league).should eq(league)
      end
    end

    describe "GET edit" do
      it "assigns the requested league as league" do
        get :edit, {:id => league.to_param}
        assigns(:league).should eq(league)
      end
    end

    describe "PUT update" do
      it "updates the requested league" do
        # Assuming there are no other leagues in the database, this
        # specifies that the League created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        League.any_instance.should_receive(:update).with({ "desc" => "new desc" })
        put :update, {:id => league.to_param, :league => { "desc" => "new desc" }}
      end


      it "assigns the requested league as league" do
        put :update, {:id => league.to_param, :league => FactoryGirl.attributes_for(:league)}
        assigns(:league).should eq(league)
      end

      it "redirects to the league" do
        put :update, {:id => league.to_param, :league => FactoryGirl.attributes_for(:league)}
        response.should redirect_to(league_path)
      end
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      @league = FactoryGirl.create(:league)
    end


    it "destroys the requested league" do

      expect {
        delete :destroy, {:id => @league.to_param}
      }.to change(League, :count).by(-1)
    end

    it "redirects to the leagues list" do
      delete :destroy, {:id => @league.to_param}
      response.should redirect_to(leagues_url)
    end
  end

  describe "POST create" do

    context "with valid attr" do
      it "creates a new League" do
        expect {
          post :create, {:league => FactoryGirl.attributes_for(:league)}
        }.to change(League, :count).by(1)
      end

      it "assigns a newly created league as league" do
        post :create, {:league => FactoryGirl.attributes_for(:league)}
        assigns(:league).should be_a(League)
        assigns(:league).should be_persisted
      end

      it "redirects to the created league" do
        post :create, {:league => FactoryGirl.attributes_for(:league)}
        response.should redirect_to(League.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved league as league" do
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        post :create, {:league => { "desc" => "invalid value" }}
        assigns(:league).should be_a_new(League)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        League.any_instance.stub(:save).and_return(false)
        post :create, {:league => { "desc" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end

  context "with invalid attributes" do

    let (:league) {League.create!(FactoryGirl.attributes_for(:league))}

    before do
      League.any_instance.stub(:save).and_return(false)
      put :update, {:id => league.to_param, :league => { "desc" => " "}}
    end

    describe "PUT update" do
      it "assigns the league as league" do
        # Trigger the behavior that occurs when invalid params are submitted
        assigns(:league).should eq(league)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        expect(response).to render_template("edit")
      end
    end

  end
end
