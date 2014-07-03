class Standing < ActiveRecord::Base
  belongs_to :team
  belongs_to :week
  has_one :league, through: :team

  validates :week, presence: true
  validates :team, uniqueness: {scope: :week}, presence: true
  validates :rank, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: {scope: :week}
  validates :tier, presence: true, numericality: { only_integer: true, greater_than: 0 }
end