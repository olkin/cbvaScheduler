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

describe TierSettingsController do

  # This should return the minimal set of attributes required to create a valid
  # TierSetting. As you add validations to TierSetting, be sure to
  # adjust the attributes here as well.
  let(:league) {FactoryGirl.create(:league)}
  let(:tier_settings) { FactoryGirl.create(:tier_setting, league: league)}
  let(:valid_attributes) {FactoryGirl.attributes_for(:tier_setting).merge({league_id: league.id})}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TierSettingsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context "entry exists" do
    before(:each) do
      tier_settings
    end

    describe "GET index" do
      it "assigns all tier_settings as @tier_settings" do
        get :index, {:league_id => league.to_param}, valid_session
        assigns(:tier_settings).should eq([tier_settings])
      end
    end

    describe "GET show" do
      it "assigns the requested tier_setting as @tier_setting" do
        get :show, {:id => tier_settings.to_param, league_id: league.to_param}, valid_session
        assigns(:tier_setting).should eq(tier_settings)
      end
    end

    describe "GET edit" do
      it "assigns the requested tier_setting as @tier_setting" do
        get :edit, {:id => tier_settings.to_param}, valid_session
        assigns(:tier_setting).should eq(tier_settings)
      end
    end


    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested tier_setting" do
          # Assuming there are no other tier_settings in the database, this
          # specifies that the TierSetting created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          TierSetting.any_instance.should_receive(:update).with({ "league_id" => "2" })
          put :update, {:id => tier_settings.to_param, :tier_setting => { "league_id" => "2" }}, valid_session
        end

        it "assigns the requested tier_setting as @tier_setting" do
          put :update, {:id => tier_settings.to_param, :tier_setting => valid_attributes}, valid_session
          assigns(:tier_setting).should eq(tier_settings)
        end

        it "redirects to the tier_setting" do
          put :update, {:id => tier_settings.to_param, :tier_setting => valid_attributes}, valid_session
          response.should redirect_to(tier_settings)
        end
      end

      describe "with invalid params" do
        it "assigns the tier_setting as @tier_setting" do
          # Trigger the behavior that occurs when invalid params are submitted
          TierSetting.any_instance.stub(:save).and_return(false)
          put :update, {:id => tier_settings.to_param, :tier_setting => { "league_id" => "invalid value" }}, valid_session
          assigns(:tier_setting).should eq(tier_settings)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          TierSetting.any_instance.stub(:save).and_return(false)
          put :update, {:id => tier_settings.to_param, :tier_setting => { "league_id" => "invalid value" }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested tier_setting" do
        expect {
          delete :destroy, {:id => tier_settings.to_param, league_id: league.to_param}, valid_session
        }.to change(TierSetting, :count).by(-1)
      end

      it "redirects to the tier_settings list" do
        delete :destroy, {:id => tier_settings.to_param, league_id: league.to_param}, valid_session
        response.should redirect_to(league_tier_settings_url(league))
      end
    end


  end


  describe "GET new" do
    it "assigns a new tier_setting as @tier_setting" do
      get :new, {:league_id=> league.to_param}, valid_session
      assigns(:tier_setting).should be_a_new(TierSetting)
    end
  end


  describe "POST create" do
    describe "with valid params" do
      it "creates a new TierSetting" do
        expect {
          post :create, {:tier_setting => valid_attributes,
                         league_id: league.to_param}, valid_session
        }.to change(TierSetting, :count).by(1)
      end

      it "assigns a newly created tier_setting as @tier_setting" do
        post :create, {:tier_setting => valid_attributes, league_id: league.to_param}, valid_session
        assigns(:tier_setting).should be_a(TierSetting)
        assigns(:tier_setting).should be_persisted
      end

      it "redirects to the created tier_setting" do
        post :create, {:tier_setting => valid_attributes, league_id: league.to_param}, valid_session
        response.should redirect_to(TierSetting.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tier_setting as @tier_setting" do
        # Trigger the behavior that occurs when invalid params are submitted
        TierSetting.any_instance.stub(:save).and_return(false)
        post :create, {:tier_setting => { "league_id" => "invalid value" }, league_id: league.to_param}, valid_session
        assigns(:tier_setting).should be_a_new(TierSetting)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TierSetting.any_instance.stub(:save).and_return(false)
        post :create, {:tier_setting => { "league_id" => "invalid value" }, league_id: league.to_param}, valid_session
        response.should render_template("new")
      end
    end
  end


end
