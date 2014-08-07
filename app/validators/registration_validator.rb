class RegistrationValidator < ActiveModel::Validator
  def validate(record)
    return if record.errors[:settings].any? or record.errors[:standings].any?

    total_teams = record.tier_settings(true).inject(0){|sum, setting| sum += setting.total_teams}
    registered_teams = record.standings.count

    record.errors[:standings] << "Number of registered teams(#{registered_teams}) differs from number of teams in settings (#{total_teams})" \
      unless total_teams == registered_teams
  end
end