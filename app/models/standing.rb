class Standing < ActiveRecord::Base
  before_create { reset_stats }
  default_scope { order('week_id, tier, rank')}

  belongs_to :team
  belongs_to :week
  has_one :league, through: :team
  has_one :tier_setting, ->(object) { where tier: object.tier }, through: :week, source: :tier_settings

  has_many :matches1, foreign_key: 'standing1_id', class_name: 'Match', dependent: :destroy
  has_many :matches2, foreign_key: 'standing2_id', class_name: 'Match', dependent: :destroy

  accepts_nested_attributes_for :team, :allow_destroy => true

  validates :week, presence: true
  validates :team, uniqueness: {scope: :week}, presence: true
  validates_numericality_of :rank, only_integer: true, greater_than: 0
  validates_uniqueness_of :rank , scope: [:week, :tier]
  validates :tier, presence: true, numericality: {only_integer: true, greater_than: 0}
  validate :team_week_league_validation

  def team_week_league_validation
    errors.add(:week, "Standing's team and week belong to different leagues") if self.team and self.week and self.team.league != self.week.league
  end

  def matches
    (matches1(true) + matches2(true)).sort_by {|match| match.game}
  end

  def details
    "(#{self.rank}) #{self.team.name}(#{self.team.captain})"
  end

  def reset_stats
    self.matches_played = 0
    self.matches_won = 0
    self.sets_played = 0
    self.sets_won = 0
    self.points_diff = 0
  end


=begin
  def update_stats
    team_stats = Hash.new(0)
    matches.each{ |match|
      stats = match.stats ( match.team2 == team )
      stats.each{|key, value| team_stats[key] += value} if stats
    }

    update_attributes(team_stats)
  end

  def setting?
    week.setting?
  end
=end
end
