class Team < ActiveRecord::Base
  before_save { email.downcase! if email}

  belongs_to :league
  has_many :standings, dependent: :destroy

  validates :name, presence: true, uniqueness: {scope: :league_id}
  validates :captain, presence: true
  validates :league_id, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, :allow_blank => true

  def self.search(search)
    Team.where('lower(name) LIKE ? OR lower(captain) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%").all if search
  end

  def short_name
    return unless name
    short_version = name.byteslice(0,17)
    short_version += '...' if name.size > short_version.size
    short_version
  end
end
