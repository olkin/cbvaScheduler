require 'spec_helper'

describe 'Standings' do
  before { @standing = FactoryGirl.create(:standing)}
  
  describe 'shows standing page' do
    it 'works! (now write some real specs)' do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get standing_path(@standing)
      response.status.should be(200)
    end
  end
end
