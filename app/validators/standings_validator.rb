
class StandingsValidator < ActiveModel::Validator
  def validate(record)

    return if record.errors.any?

    tiers_settings = record.league.tier_settings.all

    record.errors[:tier] << "Tier# #{record[:tier]} is invalid - max #{tiers_settings.size}" \
      if record[:tier] > tiers_settings.size

    total_teams = 0
    tiers_settings.each{ |setting|
      total_teams += setting.total_teams
    }

    record.errors[:tier] << "Rank# #{record[:rank]} is invalid - max #{total_teams}" \
      if record[:rank] > total_teams

    same_rank_standings = Standing.where(rank: record[:rank], week: record[:week]).to_a
    same_rank_standings.each { |standing|
      if standing[:team_id] != record[:team_id]
        team2 = standing.team
        record.errors[:rank] << "Same rank #{record[:rank]} for #{record.team.name} and #{team2.name}" \
          if team2.league_id == record.team.league_id
      end
    }
  end
end