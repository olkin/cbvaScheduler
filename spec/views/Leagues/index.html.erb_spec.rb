require 'spec_helper'

describe 'leagues/index' do

  context 'no leagues registered' do
    it 'displays a message' do
      render
      assert_select 'ul>li', count: 0
      assert_select 'div', /No open events/
    end

  end

  it 'no leagues registered no search' do
    render
    assert_select 'input.btn', value: /Search/, count: 0
  end

  context 'leagues are registered' do
    before do
      @leagues = assign(:leagues,
                        [
                            stub_model(League, description: 'League1'),
                            stub_model(League, description: 'League1')
                        ]
      )
    end

    it 'renders a list of leagues' do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select 'ul>li', :text => 'League1', :count => 2
    end

    it 'shows team search' do
      render
      rendered.should have_button 'Search'
    end

    it 'editing options are not available for non-admins' do
      render
      assert_select 'ul>li', text: /Edit/, count: 0
      assert_select 'ul>li', text: /Destroy/, count: 0
    end

    it 'search by team' do
      render
      assert_select 'input.btn', value: /Search/, count: 1
    end


  end
end
