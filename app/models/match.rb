class Match < ActiveRecord::Base
  MAX_COURTS = 14
  default_scope { order('game')}

  belongs_to :standing1, class_name: 'Standing'
  belongs_to :standing2, class_name: 'Standing'
  has_one :week, through: :standing1
  has_one :team1, through: :standing1, source: :team
  has_one :team2, through: :standing2, source: :team

  validates_presence_of :standing1, :standing2, :game, :court
  validates_numericality_of :game, greater_than: 0
  validates_numericality_of :court, greater_than: 0, less_than_or_equal_to: MAX_COURTS
  validate :setting_validation
  validates :score, score: true, allow_blank: true
  validate :standings_week_validation

  serialize :score

  def standings_week_validation
    errors.add(:base, 'Teams belong to different weeks') if self.standing1 and self.standing2 and self.standing1.week != self.standing2.week
  end


  def setting_validation
    errors.add(:base, 'Tier settings for match are not defined') if self.tier_setting.nil?
  end

  def tier_setting
    self.standing1.tier_setting if self.standing1
  end

  def opponent(standing)
    players = [self.standing1, self.standing2]
    return (players - [standing]).first if players.include? standing
    nil
  end

  def score_line(standing = self.standing1)
    return [] unless [self.standing1, self.standing2].include? standing
    score = self.score || []
    score = score.map(&:reverse)  if standing == self.standing2
    score.map{ |game_score| game_score.join(':')}.join(', ')
  end

  def stats
    set_wins = [0, 0]
    total_points_diff = 0
    match_wins = [0, 0]

    self.score.each { |set_score|
      total_points_diff += set_score[0] - set_score[1]
      winner_idx = set_score[0] > set_score[1] ? 0 : 1
      set_wins[winner_idx] += 1
    } if self.score

    if set_wins.inject(:+) > 0

      sets_diff = set_wins[0] - set_wins[1]
      if sets_diff > 0 or sets_diff == 0 and total_points_diff > 0
        match_wins = [1, 0]
      elsif sets_diff < 0 or sets_diff == 0 and total_points_diff < 0
        match_wins = [0, 1]
      else
        match_wins = [0.5, 0.5]
      end
    end

    sets_played = set_wins.inject(:+)
    total_points_diff = [total_points_diff, -total_points_diff]
    matches_played = score.blank? ? 0 : 1

    result = []
    # 2 teams = 2 times
    2.times { |idx|
      result.push({sets_won: set_wins[idx],
                   sets_played: sets_played,
                   points_diff: total_points_diff[idx],
                   matches_won: match_wins[idx],
                   matches_played: matches_played})
    }

    result
  end

  def stats_idx(standing)
    case standing
      when standing1
        0
      when standing2
        1
      else
        2
    end
  end

  private

=begin

  #TODO: DB settings
  def court_str
    (court > 12 ? "S#{court - 12}" : "C#{court}") if court
  end


=end

end
