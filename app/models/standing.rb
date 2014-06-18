class Standing < ActiveRecord::Base
  belongs_to :team
  has_one :league, through: :team

  validates :team_id, uniqueness: {scope: :week}
  validates :rank, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :tier, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :week, presence: true, numericality: { only_integer: true }
  validates_with StandingsValidator
end
