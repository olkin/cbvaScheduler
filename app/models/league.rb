class League < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :tier_settings, dependent: :destroy, inverse_of: :league
  validates :desc, presence: true, uniqueness: true
  validates :description, presence: true
end
