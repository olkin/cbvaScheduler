class Week < ActiveRecord::Base
  belongs_to :league
  has_many :tier_settings, dependent: :destroy
  has_many :standings, dependent:  :destroy

  validates_uniqueness_of :league, :scope => :week

  validates_with RegistrationValidator
  validates_with WeekSettingsValidator
  validates_with StandingsValidator
end
