class TierSetting < ActiveRecord::Base
  belongs_to :week
  has_one :league, through: :week

  validates :tier, presence: true, uniqueness: {scope: :week}, numericality: {greater_than: 0, only_integer: true}
  validates :total_teams, numericality:{ greater_than_or_equal_to: 2, only_integer: true}, allow_blank: false
  validates_numericality_of :teams_down, greater_than_or_equal_to: 0
  validates_numericality_of :teams_down, less_than: ->(setting) {setting.total_teams || 0}, allow_blank: false
  validates :day, inclusion: {in: Date::ABBR_DAYNAMES, message: 'Invalid day format %{value}'}
  validates_with  SetPointsValidator, MatchTimesValidator
  validates :schedule_pattern, tier_schedule_pattern: true, allow_blank: true
  validates :cycle, numericality:{ greater_than: 0, only_integer: true}

  serialize :schedule_pattern
  serialize :set_points
  serialize :match_times
end
