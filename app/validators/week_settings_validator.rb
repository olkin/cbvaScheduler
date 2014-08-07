class WeekSettingsValidator < ActiveModel::Validator
  def validate(record)
    return if record.errors[:settings].any?

    settings = record.tier_settings.all
    tiers = settings.map{|setting| setting.tier}
    missing_tiers = Array(1..(tiers.max||0)) - tiers

    record.errors[:settings] << "No information about #{'tier'.pluralize(missing_tiers.count)} #{missing_tiers.join(', ')}" \
      if missing_tiers.any?

    retiering_errors = validate_retiering settings, tiers.max
    record.errors[:settings] << retiering_errors if retiering_errors

    cycles_errors = validate_cycles settings unless record.errors[:settings].any?
    record.errors[:settings] << cycles_errors if cycles_errors
  end

  private
  def validate_retiering(settings, max_tier)
    no_retier_tiers = settings.select { |setting| setting.teams_down == 0 and setting.tier != max_tier }
    return "No information about retiering for #{'tier'.pluralize(no_retier_tiers.count)} #{no_retier_tiers.join(', ')}}" \
      if no_retier_tiers.any?

    teams_up = 0
    settings.each_with_index { |setting, tier|
      error_desc = "Tier #{tier + 1}"
      teams_down = setting.teams_down.to_i
      total_teams = setting.total_teams.to_i

      return  "#{error_desc}: can't move #{teams_up} #{'team'.pluralize(teams_up)} up (total: #{total_teams})"  \
        unless teams_up.between?(0, total_teams)

      return "#{error_desc}: number of teams to retier is invalid (#{teams_down} + #{teams_up} / #{total_teams})" \
        unless (teams_down + teams_up).between?(0, total_teams)

      #for the next tier teams to move up is same as teams to move down for previous tier
      teams_up = teams_down
    }

    nil
  end

  def validate_cycles(settings)
    max_cycle = settings.map { |setting| setting.schedule_pattern.size }.max

    invalid_cycle_tiers = settings.select { |setting| setting.schedule_pattern.size != max_cycle }.map { |setting| setting.tier }
    return  "Number of cycles for #{'tier'.pluralize(invalid_cycle_tiers.size)} #{invalid_cycle_tiers.join(', ')} is invalid (should be #{max_cycle})" \
      if invalid_cycle_tiers.any?

    nil
  end
end