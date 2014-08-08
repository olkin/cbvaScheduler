require 'spec_helper'

describe WeeksController do
  describe 'routing' do

    it 'routes to #index' do
      get('/leagues/1/weeks').should route_to('weeks#index', league_id: '1')
    end

    it 'routes to #show' do
      get('/weeks/2').should route_to('weeks#show', id: '2')
    end

    it 'routes to #destroy' do
      delete('/weeks/3').should route_to('weeks#destroy', id: '3')
    end

    it 'routes to #save_settings' do
      put('/weeks/2/save_settings').should route_to('weeks#save_settings', id: '2')
    end
  end
end
