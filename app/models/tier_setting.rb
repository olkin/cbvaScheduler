class TierSetting < ActiveRecord::Base
  belongs_to :week
  has_one :league, through: :week

  validates :week, presence: true
  validates :tier, presence: true, uniqueness: {scope: :week}, numericality: {greater_than: 0, only_integer: true}
  validates :total_teams, presence: true, numericality:{ greater_than_or_equal_to: 2, only_integer: true}
  validates :teams_down, numericality:  {greater_than_or_equal_to: 0}
  validates :day, inclusion: {in: Date::ABBR_DAYNAMES, message: "Invalid day format %{value}"}
  validates_with TeamsMovementValidator, SetPointsValidator, MatchTimesValidator
  validates :schedule_pattern, tier_schedule_pattern: true, allow_nil: true
  validates :cycle, numericality:{ greater_than_or_equal_to: 0, only_integer: true}, allow_nil: true

  serialize :schedule_pattern
  serialize :set_points
  serialize :times
end
