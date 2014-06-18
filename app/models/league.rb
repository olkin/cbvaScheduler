require 'json'

class League < ActiveRecord::Base
  has_many :teams, dependent: :destroy
  has_many :tier_settings, dependent: :destroy, inverse_of: :league
  has_many :standings, through: :teams
  has_many :matches, through: :teams, foreign_key: "team1_id"

  validates :desc, presence: true, uniqueness: true
  validates :description, presence: true

  DEFAULT_SCHEDULE_PATTERNS = {
      2 => [[[[1,2,1]],[[1,2,1]],[[1,2,1]]]],
      4 => [[[[1,4,1],[2,3,2]],[[1,3,1],[2,4,2]],[[1,2,1],[3,4,2]]]]
  }

  def validate_settings
    add_error = Proc.new {
        |error_msg| errors[:base] << error_msg
      return
    }

    add_error["No tiers settings"] if tier_settings.empty? or tier_settings.nil?

    tiers_supplied = []
    cycles = {}
    max_cycle = 0
    tier_settings.each{|setting|
      add_error["Tier #{setting.tier} is invalid"] unless setting.valid?
      add_error["Tier #{setting.tier} is described multiple times"] if tiers_supplied.include?setting.tier
      tiers_supplied += [setting.tier]

      cycles[setting.tier] =  JSON.parse(setting.schedule_pattern).size
      max_cycle = cycles[setting.tier] if max_cycle < cycles[setting.tier]
    }

    total_teams = 0
    if tiers_supplied.any?
      tiers_supplied.uniq!
      tiers_supplied.sort!

      missing_tiers = Array(1..tiers_supplied[-1]) - tiers_supplied
      add_error["No settings for #{'tier'.pluralize(missing_tiers.size)} #{missing_tiers.join(', ')}"] if missing_tiers.any?

      for tier in 1..tiers_supplied[-1]
        prev_tier_setting = tier_settings.all.find_by_tier(tier - 1)
        cur_tier_setting = tier_settings.all.find_by_tier tier

        teams_go_up = tier == 1 ? 0 : prev_tier_setting.teams_down
        add_error["Retiering is not happening between tier #{tier - 1} and #{tier}"] if tier > 1 and teams_go_up <= 0

        tier_total_teams = cur_tier_setting.total_teams
        add_error["Teams to move up can't exceed total number of teams in the tier(#{tier}) #{teams_go_up}/#{tier_total_teams}"] \
          if teams_go_up > tier_total_teams

        teams_go_down = tier == tiers_supplied[-1] ? 0 : cur_tier_setting.teams_down

        add_error["Teams to move down can't exceed total number of teams in the tier(#{tier}) #{teams_go_down}/#{tier_total_teams}"] \
          if teams_go_down > tier_total_teams

        add_error["Teams to move up and down can't exceed total number of teams in the tier(#{tier}) #{teams_go_up}/#{teams_go_up}/#{tier_total_teams}"] \
          if teams_go_up + teams_go_down > tier_total_teams

        cycles.keep_if{|tier, cycles_nr| cycles_nr != max_cycle}

        add_error["Number of cycles in #{'tier'.pluralize(cycles.count)} #{cycles.keys.join(', ')} differs from #{max_cycle}"] \
          if cycles.any?
      end

    end
    true
  end

  def validate_registration
    add_error = Proc.new {
        |error_msg| errors[:base] << error_msg
      return
    }

    total_teams = 0
    tier_settings.each{|setting|
      total_teams += setting.total_teams.to_i
    }

    extra_teams = teams.count - total_teams

    if extra_teams > 0
      add_error[" #{extra_teams} extra #{"team".pluralize(extra_teams)} registered"]
    elsif extra_teams < 0
      add_error["#{extra_teams.abs} more #{"team".pluralize(extra_teams.abs)} should be registered "]
    end


    true
  end
end
