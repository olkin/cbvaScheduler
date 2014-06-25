require 'spec_helper'

describe League do
  let (:league) {FactoryGirl.build(:league) }

  subject { league }

  it { should respond_to(:desc) }
  it { should respond_to(:description) }
  it { should respond_to(:start_date)}
  it { should respond_to(:teams) }
  it { should respond_to(:tier_settings)}

  it {should be_valid}

  describe "when desc is not present" do
    before { league.desc = " " }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { league.description = " " }
    it { should_not be_valid }
  end

  describe "when desc is already taken" do
    before do
      league_with_same_desc = league.dup
      league_with_same_desc.save
    end

    it { should_not be_valid }
  end

  it "allow other leagues to be created" do
    league.save
    league2 = FactoryGirl.create(:league)
    league2.should be_valid
  end
end
