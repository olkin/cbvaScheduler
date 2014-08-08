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

describe WeeksController do

  # This should return the minimal set of attributes required to create a valid
  # Week. As you add validations to Week, be sure to
  # adjust the attributes here as well.
  before {
    @week = FactoryGirl.create(:week)
  }

  #let(:valid_attributes) {FactoryGirl.build(:week, league: league).attributes}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WeeksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns week as @week' do
      get :index, {league_id: @week.league.to_param}, valid_session
      assigns(:week).should eq(@week)
    end

    it 'displays current week\'s details' do
      get :index, {league_id: @week.league.to_param}, valid_session
      response.should render_template('show')
    end
  end

  describe 'GET show' do
    it 'assigns the requested week as @week' do
      get :show, {:id => @week.to_param}, valid_session
      assigns(:week).should eq(@week)
    end
  end


  describe 'DELETE destroy' do
    it 'destroys the requested week' do
      expect {
        delete :destroy, {:id => @week.to_param}, valid_session
      }.to change(Week, :count).by(-1)
    end

    it 'redirects to the league page' do
      delete :destroy, {:id => @week.to_param}, valid_session
      response.should redirect_to(league_url(@week.league))
    end
  end

  describe 'PUT save_settings' do
    it 'adds new week' do
      expect {
        put :save_settings, {:id => @week.to_param}, valid_session
      }.to change(Week, :count).by(1)
    end

    it 'updates existing week if exists' do
      put :save_settings, {:id => @week.to_param}, valid_session

      expect {
        put :save_settings, {:id => @week.to_param}, valid_session
      }.not_to change(Week, :count).by(1)
    end

    it 'redirects to league page' do
      put :save_settings, {:id => @week.to_param}, valid_session
      response.should redirect_to(league_url(@week.league))
    end
  end

end
