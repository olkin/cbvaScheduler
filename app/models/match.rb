class Match < ActiveRecord::Base
  MAX_OF_GAMES = 4
  MAX_COURTS = 12
  belongs_to :team1, class_name: "Team"
  belongs_to :team2, class_name: "Team"
  belongs_to :week
  has_one :league, through: :week

  serialize :score

  validates_presence_of :team1, :team2, :game, :court
  validates_numericality_of :game, :greater_than => 0, :less_than_or_equal_to => MAX_OF_GAMES
  validates_numericality_of :court, :greater_than => 0, :less_than_or_equal_to => MAX_COURTS
  validates :score, :allow_nil => true, score: true
end
