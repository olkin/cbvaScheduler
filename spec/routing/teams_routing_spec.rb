require 'spec_helper'

describe TeamsController do
  #let (:league) {FactoryGirl.create(:league)}
  describe 'routing' do

    it 'routes to #index_1' do
      get('leagues/1/teams').should route_to('teams#index', :league_id => '1')
    end

    it 'routes to #new' do
      get('/leagues/1/teams/new').should route_to('teams#new', league_id: '1')
    end

    it 'routes to #edit' do
      get('/teams/1/edit').should route_to('teams#edit', :id => '1')
    end

    it 'routes to #create' do
      post('/leagues/1/teams').should route_to('teams#create', league_id: '1')
    end

    it 'routes to #update' do
      put('/teams/1').should route_to('teams#update', :id => '1')
    end

    it 'routes to #destroy' do
      delete('/teams/1').should route_to('teams#destroy', :id => '1')
    end

  end
end
