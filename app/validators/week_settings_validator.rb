class WeekSettingsValidator < ActiveModel::Validator
  def validate(record)
    return if record.errors[:settings].any?

    settings = record.tier_settings.all
    tiers = settings.map{|setting| setting.tier}
    missing_tiers = Array(1..(tiers.max||0)) - tiers

    record.errors[:settings] << "No information about #{'tier'.pluralize(missing_tiers.count)} #{missing_tiers.join(', ')}}" \
      if missing_tiers.any?

    no_retier_tiers = settings.select{|setting| setting.teams_down == 0 and setting.tier != tiers.max}
    record.errors[:settings] << "No information about retiering for #{'tier'.pluralize(no_retier_tiers.count)} #{no_retier_tiers.join(', ')}}" \
      if no_retier_tiers.any?

    return if record.errors[:settings].any?

    teams_up = 0
    settings.each_with_index { |setting, tier|
      teams_down = setting.teams_down.to_i
      total_teams = setting.total_teams.to_i

      record.errors.add(:settings, "Tier #{tier + 1}: can't move #{teams_up} #{'team'.pluralize(teams_up)} up (total: #{total_teams})") unless teams_up.between?(0, total_teams)
      record.errors.add(:settings, "Tier #{tier + 1}: number of teams to retier is invalid (#{teams_down} + #{teams_up} / #{total_teams})") unless (teams_down + teams_up).between?(0, total_teams)

      #for the next tier teams to move up is same as teams to move down for previous tier
      teams_up = teams_down
    }


    max_cycle = settings.inject(0){|max, setting|
      cycles = eval(setting.schedule_pattern).size
      cycles > max ? cycles : max
    }

    invalid_cycle_tiers = settings.select{|setting| eval(setting.schedule_pattern).size != max_cycle}.map{|setting| setting.tier}
    record.errors.add(:settings, "Number of cycles for #{'tier'.pluralize(invalid_cycle_tiers.size)} #{invalid_cycle_tiers.join(', ')} is invalid (should be #{max_cycle})") if invalid_cycle_tiers.any?
  end
end