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
 # let(:league) {FactoryGirl.create(:league)}
  #let(:week) {FactoryGirl.create(:week, league: league)}
  let(:week) {FactoryGirl.create(:week)}
  let(:tier_setting) {FactoryGirl.build(:tier_setting, week: week)}
  let(:valid_attributes) {tier_setting.attributes}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TierSettingsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all tier_settings as @tier_settings" do
      tier_setting.save!
      get :index, {week_id: tier_setting.week.to_param}, valid_session
      assigns(:tier_settings).should eq([tier_setting])
    end
  end

  describe "GET show" do
    it "assigns the requested tier_setting as @tier_setting" do
      tier_setting.save!
      get :show, {:id => tier_setting.to_param}, valid_session
      assigns(:tier_setting).should eq(tier_setting)
    end
  end

  describe "GET new" do
    it "assigns a new tier_setting as @tier_setting" do
      get :new, {week_id: week.to_param}, valid_session
      assigns(:tier_setting).should be_a_new(TierSetting)
    end
  end

  describe "GET edit" do
    it "assigns the requested tier_setting as @tier_setting" do
      tier_setting.save!
      get :edit, {:id => tier_setting.to_param}, valid_session
      assigns(:tier_setting).should eq(tier_setting)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TierSetting" do
        expect {
          post :create, {:tier_setting => valid_attributes, week_id: week.to_param}, valid_session
        }.to change(TierSetting, :count).by(1)
      end

      it "assigns a newly created tier_setting as @tier_setting" do
        post :create, {:tier_setting => valid_attributes,  week_id: week.to_param}, valid_session
        assigns(:tier_setting).should be_a(TierSetting)
        assigns(:tier_setting).should be_persisted
      end

      it "redirects to the created tier_setting" do
        post :create, {:tier_setting => valid_attributes, week_id: week.to_param}, valid_session
        response.should redirect_to(week_tier_settings_url(week))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tier_setting as @tier_setting" do
        # Trigger the behavior that occurs when invalid params are submitted
        TierSetting.any_instance.stub(:save).and_return(false)
        post :create, {:tier_setting => { "week_id" => "invalid value" },  week_id: week.to_param}, valid_session
        assigns(:tier_setting).should be_a_new(TierSetting)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TierSetting.any_instance.stub(:save).and_return(false)
        post :create, {:tier_setting => { "week_id" => "invalid value" },  week_id: week.to_param}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tier_setting" do
        tier_setting.save!
        # Assuming there are no other tier_settings in the database, this
        # specifies that the TierSetting created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TierSetting.any_instance.should_receive(:update).with({ "week_id" => "1" })
        put :update, {:id => tier_setting.to_param, :tier_setting => { "week_id" => "1" }}, valid_session
      end

      it "assigns the requested tier_setting as @tier_setting" do
        tier_setting.save!
        put :update, {:id => tier_setting.to_param, :tier_setting => valid_attributes}, valid_session
        assigns(:tier_setting).should eq(tier_setting)
      end

      it "redirects to the tier_setting" do
        tier_setting.save!
        put :update, {:id => tier_setting.to_param, :tier_setting => valid_attributes}, valid_session
        response.should redirect_to(tier_setting)
      end
    end

    describe "with invalid params" do
      it "assigns the tier_setting as @tier_setting" do
        tier_setting.save!
        # Trigger the behavior that occurs when invalid params are submitted
        TierSetting.any_instance.stub(:save).and_return(false)
        put :update, {:id => tier_setting.to_param, :tier_setting => { "week_id" => "invalid value" }}, valid_session
        assigns(:tier_setting).should eq(tier_setting)
      end

      it "re-renders the 'edit' template" do
        tier_setting.save!
        # Trigger the behavior that occurs when invalid params are submitted
        TierSetting.any_instance.stub(:save).and_return(false)
        put :update, {:id => tier_setting.to_param, :tier_setting => { "week_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested tier_setting" do
      tier_setting.save!
      expect {
        delete :destroy, {:id => tier_setting.to_param}, valid_session
      }.to change(TierSetting, :count).by(-1)
    end

    it "redirects to the tier_settings list" do
      tier_setting.save!
      delete :destroy, {:id => tier_setting.to_param}, valid_session
      response.should redirect_to(week_tier_settings_url(week))
    end
  end

end
