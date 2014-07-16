class Standing < ActiveRecord::Base
  belongs_to :team
  belongs_to :week
  has_one :league, through: :team

  accepts_nested_attributes_for :team, :allow_destroy => true

  validates :week, presence: true
  validates :team, uniqueness: {scope: :week}, presence: true
  validates :rank, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: {scope: :week}, allow_nil: true
  validates :tier, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def update_stats
    #nulify all stats
    puts "UDPATE_STATS for team #{self.team.name}"

    scores = self.week.matches.all.inject([]) {|scores, match|
      scores += match.score if match.team1 == self.team and match.score and !match.score.blank?
      scores
    }
    puts "Scores as team1: #{scores.inspect}"

    scores = self.week.matches.all.inject(scores){ |scores, match|
      scores += match.score.map{|score| score.reverse} if match.team2 == self.team and match.score and !match.score.blank?
      scores
    }

    puts "Scores as team1/2: #{scores.inspect}"


    stats = {matches_played: 0, matches_won:0, sets_played: 0, sets_won: 0, points_diff: 0}

    total_sets = scores.size
    stats[:matches_played] += 1
    stats[:sets_played] += total_sets
    sets_won = 0
    total_points_diff = 0
    puts "Scores for the team are: #{scores.inspect}"
    scores.each do |set_score|
      points_diff = set_score[0] - set_score[1]
      sets_won += 1 if points_diff > 0
      total_points_diff += points_diff
    end

    stats[:points_diff] += total_points_diff
    stats[:sets_won] += sets_won

    #who won the match?
    won_sets_diff = 2 * sets_won - total_sets
    if won_sets_diff > 0
      stats[:matches_won] += 1
    elsif won_sets_diff == 0
      if total_points_diff > 0
        stats[:matches_won] += 1
      elsif total_points_diff == 0
        stats[:matches_won] += 0.5
      end
    end

    self.update_attributes(stats)
  end
end
