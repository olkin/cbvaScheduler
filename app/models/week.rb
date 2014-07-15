class Week < ActiveRecord::Base
  belongs_to :league
  has_many :tier_settings, dependent: :destroy
  has_many :standings, dependent:  :destroy
  has_many :matches, dependent: :destroy

  validates_uniqueness_of :league, :scope => :week
  validates :week, numericality:{ greater_than_or_equal_to: 0, only_integer: true}, allow_nil: true

  validates_with RegistrationValidator
  validates_with WeekSettingsValidator
  validates_with StandingsValidator
end
