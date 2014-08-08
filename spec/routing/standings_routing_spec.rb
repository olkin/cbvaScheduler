require 'spec_helper'

describe StandingsController do
  describe 'routing' do
    it 'routes to #new' do
      get('/weeks/2/standings/new').should route_to('standings#new', week_id: '2')
    end

    it 'routes to #show' do
      get('/standings/3').should route_to('standings#show', :id => '3')
    end

    it 'routes to #edit' do
      get('/standings/2/edit').should route_to('standings#edit', id: '2')
    end

    it 'routes to #create' do
      post('/weeks/2/standings').should route_to('standings#create', week_id: '2')
    end

    it 'routes to #update' do
      put('/standings/3').should route_to('standings#update', id: '3')
    end

    it 'routes to #destroy' do
      delete('/standings/3').should route_to('standings#destroy', id: '3')
    end

  end
end
