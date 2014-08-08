require 'spec_helper'

describe MatchesController do

  describe 'PUT update with valid attributes' do
    it 'updates the requested league' do
      # Assuming there are no other leagues in the database, this
      # specifies that the League created on the previous line
      # receives the :update_attributes message with whatever params are
      # submitted in the request.
      League.any_instance.should_receive(:update).with({'desc' => 'new desc'})
      put :update, {:id => @league.to_param, :league => {'desc' => 'new desc'}}
    end


    it 'assigns the requested league as league' do
      put :update, {:id => @league.to_param, :league => FactoryGirl.attributes_for(:league)}
      assigns(:league).should eq(@league)
    end

    it 'redirects to the league' do
      put :update, {:id => @league.to_param, :league => FactoryGirl.attributes_for(:league)}
      response.should redirect_to(leagues_path)
    end
  end


  describe 'PUT update with invalid attributes' do
    it 'assigns the league as league' do
      # Trigger the behavior that occurs when invalid params are submitted
      assigns(:league).should eq(league)
    end

    it "re-renders the 'edit' template" do
      # Trigger the behavior that occurs when invalid params are submitted
      expect(response).to render_template('edit')
    end
  end

end