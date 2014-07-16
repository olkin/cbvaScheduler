class Match < ActiveRecord::Base
  belongs_to :team1, class_name: "Team"
  belongs_to :team2, class_name: "Team"
  belongs_to :week
  has_one :league, through: :week

  serialize :score

  validates_presence_of :team1, :team2, :game, :court
  validates :score, :allow_nil => true, score: true

  def team1_standing
    self.week.standings.find_by(team: team1)
  end

  def team2_standing
    self.week.standings.find_by(team: team2)
  end

  def stats
    return nil unless self.score and !self.score.blank?
    set_results = [0,0]
    points_difference = 0
    self.score.each { |set_score|
      points_difference += set_score[0] - set_score[1]
      team_idx_won = set_score[0] > set_score[1] ? 0 : 1
      set_results[team_idx_won] += 1
    }

    if set_results[0] > set_results[1]
      match_result =  [1,0]
    elsif set_results[0] == set_results[1]
      if points_difference > 0
        match_result =  [1, 0]
      elsif points_difference == 0
        match_result =  [0.5, 0.5]
      else
        match_result =  [0, 1]
      end
    else
      match_result = [0,1]
    end

    {sets_won: set_results, matches_won: match_result, points_diff: points_difference}
  end



end
