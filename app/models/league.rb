class League < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :tier_settings, dependent: :destroy, inverse_of: :league
  validates :desc, presence: true, uniqueness: true
  validates :description, presence: true

  def validate_settings
    add_error = Proc.new {
        |error_msg| errors[:base] << error_msg
      return
    }

    tier_settings = self.tier_settings
    add_error["No tiers settings"] if tier_settings.empty? or tier_settings.nil?

    tiers_supplied = []
    tier_settings.each{|setting|
      add_error["Tier #{setting.tier} is described multiple times"] if tiers_supplied.include?setting.tier
      tiers_supplied += [setting.tier]
    }

    if tiers_supplied.any?
      missing_tiers = Array(1..tiers_supplied[-1]) - tiers_supplied
      add_error["No settings for #{'tier'.pluralize(missing_tiers.size)} #{missing_tiers.join(', ')}"] if missing_tiers.any?
    end

    # TODO: teams_down check

    # TODO: cycles number should be same
  end
end
