class League < ActiveRecord::Base
  validates :desc, presence: true, uniqueness: true
  validates :description, presence: true
end
