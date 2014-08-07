class Match < ActiveRecord::Base
  MAX_COURTS = 14

  belongs_to :standing1, class_name: 'Standing'
  belongs_to :standing2, class_name: 'Standing'
  has_one :week, through: :standing1

  validates_presence_of :standing1, :standing2, :game, :court
  validates_numericality_of :game, greater_than: 0
  validates_numericality_of :court, greater_than: 0, less_than_or_equal_to: MAX_COURTS
  validates :score, score: true, allow_blank: true
  validate :standings_week_validation
  validate :tier_setting_existance_validation

  serialize :score

  def standings_week_validation
    errors.add(:base, "Teams belong to different weeks") if self.standing1 and self.standing2 and self.standing1.week != self.standing2.week
  end


  def tier_setting_existance_validation
    errors.add(:base, "Tier settings for match are not defined") if self.tier_setting.nil?
  end

  def tier_setting
    self.standing1.tier_setting if self.standing1
  end

=begin



  def statistics
    self.stats(score)
  end

  #TODO: DB settings
  def court_str
    (court > 12 ? "S#{court - 12}" : "C#{court}") if court
  end

  def stats(reverse = false)
    return if score.blank?

    set_wins = [0, 0]
    total_points_diff = 0

    score.each { |set_score|
      total_points_diff += set_score[0] - set_score[1]
      winner_idx = set_score[0] > set_score[1] ? 0 : 1
      set_wins[winner_idx] += 1
    }

    if reverse
      set_wins.reverse!
      total_points_diff = -total_points_diff
    end

    {sets_won: set_wins[0],
     sets_played: set_wins.inject(:+),
     points_diff: total_points_diff,
     matches_won: match_wins(set_wins, total_points_diff)[0],
     matches_played: 1}
  end

  private
  def match_wins(set_wins = [0, 0], points_diff = 0)
    return unless set_wins.inject(:+) > 0

    if set_wins[0] > set_wins[1]
      match_wins = [1, 0]
    elsif set_wins[1] > set_wins[0]
      match_wins = [0, 1]
    else
      if points_diff > 0
        match_wins = [1, 0]
      elsif points_diff == 0
        match_wins = [0.5, 0.5]
      else
        match_wins = [0, 1]
      end
    end

    match_wins
  end

=end

end
