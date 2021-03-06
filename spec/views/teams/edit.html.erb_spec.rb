require 'spec_helper'

describe 'teams/edit' do
  let(:league) {FactoryGirl.create(:league)}
  before(:each) do
    @team = assign(:team, stub_model(Team,
      :name => 'MyString',
      :captain => 'MyString',
      :email => 'MyString',
      :league_id => league.id
    ))
  end

  it 'renders the edit team form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', team_path(@team), 'post' do
      assert_select 'input#team_name[name=?]', 'team[name]'
      assert_select 'input#team_captain[name=?]', 'team[captain]'
      assert_select 'input#team_email[name=?]', 'team[email]'
    end
  end
end
