require 'spec_helper'

describe Team do
    before do
      @team = FactoryGirl.create(:team)
    end

    subject { @team }

    it { should respond_to(:name) }
    it { should respond_to(:captain) }
    it { should respond_to(:email) }
    it { should respond_to(:league) }
    it { should respond_to(:league_id) }
    its(:league) { should eq @team.league }

    it { should be_valid }

    describe "when name is not present" do
      before { @team.name = " " }
      it { should_not be_valid }
    end

    describe "when captain name is not present" do
      before { @team.captain = " " }
      it { should_not be_valid }
    end


    describe "when email is not present" do
      before { @team.email = " " }
      it { should be_valid }
    end

    describe "when email is not present" do
      before { @team.email = nil }
      it { should be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          @team.email = invalid_address
          expect(@team).not_to be_valid
        end
      end
    end

    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @team.email = valid_address
          expect(@team).to be_valid
        end
      end
    end

    describe "when league_id is not present" do
      before { @team.league_id = nil }
      it { should_not be_valid }
    end

    it "should destroy associated teams" do
      teams = @team.league.teams.all.to_a
      @team.league.destroy
      expect(teams).not_to be_empty
      teams.each do |team|
        expect(Team.where(id: team.id)).to be_empty
      end
    end

  describe "when team already exists" do
    it "doesn't accept another team with same name for same league" do
      team2 = @team.dup
      team2.save
      team2.should_not be_valid
    end

    it "accepts a team with same name for different league" do
      team2 = @team.dup
      league2 = @team.league.dup
      league2.desc = "Another name"
      league2.save

      team2.league_id = league2.id
      team2.should be_valid
    end
  end

end
