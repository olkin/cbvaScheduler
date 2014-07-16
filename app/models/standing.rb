class Standing < ActiveRecord::Base
  belongs_to :team
  belongs_to :week
  has_one :league, through: :team

  accepts_nested_attributes_for :team, :allow_destroy => true

  validates :week, presence: true
  validates :team, uniqueness: {scope: :week}, presence: true
  validates :rank, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: {scope: :week}, allow_nil: true
  validates :tier, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def matches
    self.week.matches.all.select{|match| match.team1 == self.team || match.team2 == self.team}
  end

  def update_stats
    matches_played = matches.select{|match| match.score and !match.score.blank?}

    scores = matches_played.inject([]) {|scores, match|
      score = match.score
      score = score.map{|score| score.reverse} if match.team2 == self.team
      scores += score
      scores
    }

    team_stats = {matches_played: matches_played.size, matches_won:0, sets_played: scores.size, sets_won: 0, points_diff: 0}

    matches_played.each { |match|
      stats = match.stats
      if stats
        team_stats[:matches_won] += (match.team1 == self.team ? stats[:matches_won][0] : stats[:matches_won][1])
        team_stats[:sets_won] += (match.team1 == self.team ? stats[:sets_won][0] : stats[:sets_won][1])
        team_stats[:points_diff] += (match.team1 == self.team ? stats[:points_diff] : -stats[:points_diff])
      end
    }

    self.update_attributes(team_stats)
  end
end
