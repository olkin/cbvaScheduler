class RegistrationValidator < ActiveModel::Validator
  def validate(record)
    return if record.errors[:settings].any? or record.errors[:standings].any?

    settings = record.tier_settings.all || []
    standings = record.standings || []


    total_teams = settings.map{|setting| setting.total_teams}.inject(:+) || 0
    registered_teams = standings.size

    record.errors[:standings] << "Number of registered teams differs from number of teams in settings (#{total_teams}/ #{registered_teams})" \
      if total_teams != registered_teams
  end
end