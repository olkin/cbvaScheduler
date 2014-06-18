class Team < ActiveRecord::Base
  before_save { email.downcase! if email}

  belongs_to :league
  has_many :standings
  has_many :matches, foreign_key: "team1_id"

  validates :name, presence: true, uniqueness: {scope: :league_id}
  validates :captain, presence: true
  validates :league_id, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, :allow_nil => true, :allow_blank => true
end
