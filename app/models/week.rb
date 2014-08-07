class Week < ActiveRecord::Base
  belongs_to :league
  has_many :tier_settings, dependent: :destroy
  has_many :standings, dependent:  :destroy
  has_many :matches, through: :standings, source: :matches1

  validates :week, numericality:{ greater_than_or_equal_to: 0, only_integer: true}, allow_nil: true
  validates_uniqueness_of :week, scope: :league

  validates_with RegistrationValidator
  validates_with WeekSettingsValidator
  validates_with StandingsValidator

=begin
  def setting?
    week.nil?
  end
=end
end
