require 'json'

class League < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :weeks, dependent: :destroy
  has_many :matches, through: :teams, foreign_key: "team1_id"

  validates :desc, presence: true, uniqueness: true
  validates :description, presence: true

  DEFAULT_SCHEDULE_PATTERNS = {
      2 => [[[[1,2,1]],[[1,2,1]],[[1,2,1]]]],
      4 => [[[[1,4,1],[2,3,2]],[[1,3,1],[2,4,2]],[[1,2,1],[3,4,2]]]]
  }

  def cur_week
    cur_week_nr = Week.maximum("week") || 0
    self.weeks.find_by(week: cur_week_nr)
  end

end
