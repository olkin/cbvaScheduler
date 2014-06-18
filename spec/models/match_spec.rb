require 'spec_helper'

describe Match do
  before do
    @tier_settings = FactoryGirl.create(:tier_setting)
    @match = FactoryGirl.create(:match, league: @tier_settings.league)
  end

  it {@match.should be_valid}

  describe "invalid match" do
    it "doesn't have team1" do
      @match.team1 = nil
      @match.should_not be_valid
    end

    it "doesn't have team2" do
      @match.team2 = nil
      @match.should_not be_valid
    end

    it "doesn't have court" do
      @match.court = nil
      @match.should_not be_valid
    end

    it "doesn't have game nr" do
      @match.game = nil
      @match.should_not be_valid
    end

    it "game nr is invalid" do
      @match.game = 0
      @match.should_not be_valid
    end

    it "game nr is too big" do
      @match.game = 10
      @match.should_not be_valid
    end

    it "court nr if invalid" do
      @match.court = 0
      @match.should_not be_valid
    end

    it "court nr is too big" do
      @match.court = 20
      @match.should_not be_valid
    end
  end

  it "accepts valid score" do
    valid_match_scores = [ [[21,15], [13,21], [7,8]],
                           [[21,15], [21,16]],
                           [[21,15], [15,21]],
                           [[20,19]],
                           [[24,22]]
                          ]
    valid_match_scores.each do |valid_score|
      @match.score = valid_score
      @match.should be_valid
    end
  end

  describe "invalid score" do
    it "doesn't accept invalid game score" do
      invalid_game_scores = [ [15,15],
                        [1,2],
                        [nil, 6],
                        [6],
                        21, 6,
                        nil,
                        [-1,17]
      ]

      invalid_game_scores.each do |invalid_game_score|
        @match.score = [invalid_game_score]
        @match.should_not be_valid
      end
    end

    it "doesn't accept invalid match score" do
      invalid_match_scores = [ [[18,13],[13,19]],
                               [[21,15],[15,21],[21,15],[15,21]],
                               [[21,15],[21,18],[7,8]],
                               [[21,15],nil,[7,8]],
                               [[21,15],[-2,13]]

      ]
      invalid_match_scores.each do |invalid_match_score|
        @match.score = invalid_match_score
        @match.should_not be_valid
      end
    end
  end
end
