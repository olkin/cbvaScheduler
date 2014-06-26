class Week < ActiveRecord::Base
  belongs_to :league
  has_many :tier_settings

  attr_reader :settings

  serialize :standings
  serialize :settings
  validates_uniqueness_of :league, :scope => :week
  validate :no_dups_standings, :no_nil_standings
  validate :valid_nr_of_registered_teams, :valid_nr_of_cycles, :valid_retier, on: :index

  def no_dups_standings
    return unless standings
    dups = standings.select { |team| standings.count(team) > 1 }.uniq
    errors.add(:standings, "Duplication of #{'team'.pluralize(dups.size)} #{dups.join(', ')}") if dups.any?
  end

  def no_nil_standings
    return unless standings
    nils_count = standings.count(nil)
    errors.add(:standings, "#{nils_count} #{'Empty spot'.pluralize(nils_count)} detected") unless nils_count == 0
  end

  def valid_retier
    return unless settings
    return if errors[:settings].any?
    teams_up = 0  # number of teams to move up for tier 1
    settings.each_with_index { |setting, tier|
      teams_down = setting[:teams_down].to_i || 0
      total_teams = setting[:total_teams].to_i || 0
      errors.add(:settings, "No retier between tier #{tier + 1} and #{tier + 2}") if teams_down == 0 and tier + 1 < settings.size
      errors.add(:settings, "Tier #{tier + 1}: can't move #{teams_down} #{'team'.pluralize(teams_down)} down (total: #{total_teams})") unless teams_down.between?(0, total_teams)
      errors.add(:settings, "Tier #{tier + 1}: can't move #{teams_up} #{'team'.pluralize(teams_up)} up (total: #{total_teams})") unless teams_up.between?(0, total_teams)
      errors.add(:settings, "Tier #{tier + 1}: number of teams to retier is invalid (#{teams_down} + #{teams_up} / #{total_teams})") unless (teams_down + teams_up).between?(0, total_teams)

      #for the next tier teams to move up is same as teams to move down for previous tier
      teams_up = teams_down
    }
  end

  def valid_nr_of_registered_teams
    return if errors.any?
    total_teams = settings ? settings.inject(0){ |teams, setting| teams + setting[:total_teams]} : 0
    registered_teams = standings ? standings.size : 0
    errors.add(:base, "Number of registered teams differs from number of teams in settings (#{total_teams}/ #{registered_teams})") if total_teams != registered_teams
  end

  def valid_nr_of_cycles
    return unless settings
    cycles  = settings.map { |setting| (setting and setting[:schedule_pattern]) ? setting[:schedule_pattern].size : 0}
    max_cycle = cycles.max
    invalid_cycle_tiers = cycles.map.with_index{|cycle, tier| tier if cycle != max_cycle}.compact
    errors.add(:settings, "Number of cycles for #{'Tier'.pluralize(invalid_cycle_tiers.size)} #{invalid_cycle_tiers.join(', ')} is invalid (should be #{max_cycle})") if invalid_cycle_tiers.any?
  end

end
