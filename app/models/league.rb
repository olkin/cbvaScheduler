class League < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  validates :desc, presence: true, uniqueness: true
  validates :description, presence: true
end
