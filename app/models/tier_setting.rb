class TierSetting < ActiveRecord::Base
  belongs_to :league

  validates :tier,
            presence: true,
            uniqueness: {scope: :league_id},
            numericality: {only_integer: true, greater_than: 0}
  validates :total_teams, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 2}
  validates :teams_down, presence:  true,
            numericality: {only_integer: true,
                           greater_than_or_equal_to: 0, less_than_or_equal_to: :total_teams,
                           message: "%(value) for teams moving down is invalid"}

  validates :day, inclusion: { in: Date::ABBR_DAYNAMES,
                               message: "'%{value}' is not a valid day" }

  validates :league_id, presence: true

  validates :schedule_pattern, tier_schedule_pattern: true
end