require 'spec_helper'

describe Match do
  before do
    @match = FactoryGirl.build(:match)
  end

  subject { @match }
  it { should_not be_valid }
  it { should respond_to :standing1 }
  it { should respond_to :standing2 }
  it { should respond_to :score }
  it { should respond_to :court }
  it { should respond_to :game }

  context 'has tier settings associated' do
    before {
      @tier_setting = FactoryGirl.create(:tier_setting, week: @match.week)
      @match.save
    }

    it { should be_valid }

    it 'doesn\'t have standing1' do
      @match.standing1 = nil
      @match.should_not be_valid
    end

    it 'doesn\'t have standing2' do
      @match.standing2 = nil
      @match.should_not be_valid
    end

    it 'standing1 and standing2 belong to same week' do
      new_week = FactoryGirl.create(:week)
      @match.standing1.week = new_week
      @match.should_not be_valid
    end

    it 'has valid court' do
      invalid_courts = [nil, 0, -1, 20]
      invalid_courts.each do |court|
        @match.court = court
        @match.should_not be_valid
      end
    end

    it 'has valid game nr' do
      invalid_game_nrs = [nil, 0, -1]
      invalid_game_nrs.each do |game|
        @match.game = game
        @match.should_not be_valid
      end
    end


    it 'has valid tier settings for the match' do
      @match.standing1.tier_setting.should_not be_nil
    end

    context 'validates score' do
      before { @tier_setting.set_points = [21, 21, 15] }

      it 'accepts valid score' do

        valid_match_scores = [nil,
                              [[21, 15], [13, 21], [7, 8]],
                              [[21, 15], [21, 16]],
                              [[21, 15], [15, 21]],
                              [[20, 19]],
                              [[24, 22]],
                              [[0, 0]]
        ]

        valid_match_scores.each do |valid_score|
          @match.score = valid_score
          @match.should be_valid
        end
      end

      it 'doesn\'t accept invalid game score' do
        invalid_game_scores = [[15, 15],
                               [1, 2],
                               [nil, 6],
                               [6],
                               21, 6,
                               nil,
                               [-1, 17]
        ]

        invalid_game_scores.each do |invalid_game_score|
          @match.score = [invalid_game_score]
          @match.should_not be_valid
        end
      end

      it 'doesn\'t accept invalid match score' do
        invalid_match_scores = [[[18, 13], [13, 19]],
                                [[21, 15], [15, 21], [21, 15], [15, 21]],
                                [[21, 15], [21, 18], [7, 8]],
                                [[21, 15], nil, [7, 8]],
                                [[21, 15], [-2, 13]]

        ]
        invalid_match_scores.each do |invalid_match_score|
          @match.score = invalid_match_score
          @match.should_not be_valid
        end
      end
    end

  end

end
