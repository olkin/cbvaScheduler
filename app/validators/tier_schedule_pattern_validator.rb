class TierSchedulePatternValidator < ActiveModel::Validator
  MAX_GAMES_PER_DAY = 1000
  MAX_BYES = 1000
  GAME_SCH_MEMBERS_COUNT = 3
  MAX_COURTS = 14

  def validate(record)
    add_error = Proc.new {
        |error_msg| record.errors[:schedule_pattern] << error_msg
      return
    }

    schedule_pattern = record.schedule_pattern

    format_error = validate_format schedule_pattern
    add_error[format_error] if format_error


    # check out that same team/court is not played/used at the same time
    schedule_pattern.each_with_index { |cycle_schedule, idx|
      validate_cycle cycle_schedule, idx, (record.total_teams unless record.errors[:total_teams].any?)
    }
  end

  private
  def validate_format(schedule_pattern)
    return "Invalid format of cycles or empty: #{schedule_pattern.to_s}" \
      unless schedule_pattern.is_a? Array and schedule_pattern.any?

    schedule_pattern.each_with_index { |cycle_schedule, idx|
      error_desc = "cycle # #{idx + 1}"
      return "Invalid format for #{error_desc}" unless cycle_schedule.is_a?Array
      return "No schedule for #{error_desc}" if cycle_schedule.empty?

      return "Invalid number of timeslots(#{cycle_schedule.size}) for #{error_desc} " \
        unless cycle_schedule.size.between?(MAX_GAMES_PER_DAY - MAX_BYES, MAX_GAMES_PER_DAY)

      cycle_schedule.each_with_index { |timeslot_schedule, timeslot_idx|
        error_desc = "game ##{timeslot_idx + 1}[#{idx + 1}]"
        return "Invalid format for #{error_desc}" unless timeslot_schedule.is_a? Array

        timeslot_schedule.each { |game_schedule|
          return "Invalid format for #{error_desc}: #{game_schedule.to_s}" \
            unless game_schedule.is_a? Array and game_schedule.size == GAME_SCH_MEMBERS_COUNT

          #game_schedule.map! { |x| x.to_i if x }
          team1, team2, court = game_schedule
          return "Invalid format for team for #{error_desc}: #{game_schedule.to_s}" \
            unless team1.is_a? Fixnum and team1 > 0 and team2.is_a? Fixnum and team2 > 0

          return "Team #{team1} plays itself for #{error_desc}" if team1 == team2

          return "Court #{court} is invalid for #{error_desc}" \
            unless court.is_a? Fixnum and court.between?(1, MAX_COURTS)
        }
      }
    }
    nil
  end

  def validate_cycle(cycle_schedule, cycle, total_teams)
    duplicates_errors = find_duplicates cycle_schedule, cycle
    return duplicates_errors if duplicates_errors

    teams_played = cycle_schedule.map{|ts_schedule| ts_schedule.map{|game| [game[0], game[1]]}}.flatten

    invalid_schedule_teams = teams_played.select{|rank| !teams_played.count(rank).between?(MAX_GAMES_PER_DAY - MAX_BYES, MAX_GAMES_PER_DAY)}.uniq
    return "Invalid # of games in schedule for #{'team'.pluralize(invalid_schedule_teams.size)} #{invalid_schedule_teams.join(', ')}" \
      if invalid_schedule_teams.any?


    if total_teams
      teams = Array(1..total_teams)

      missing_teams = teams - teams_played
      return "No games for #{'team'.pluralize(missing_teams.size)} #{missing_teams.join(',')}" if missing_teams.any?

      extra_teams = teams_played - teams
      return "Schedule for extra #{'team'.pluralize(extra_teams.size)} #{extra_teams.join(',')}" if extra_teams.any?
    end
  end

  def find_duplicates(cycle_schedule, cycle)
    cycle_schedule.each_with_index { |ts_schedule, idx|
      error_desc = "cycle##{cycle + 1} game##{idx + 1}"
      ranks = ts_schedule.map { |game| [game[0], game[1]] }.flatten
      duplicates = ranks.select { |rank| ranks.count(rank) > 1 }.uniq
      return "#{pluralize(duplicates.count, 'Team')} #{duplicates.join(', ')} play at the same time in different location(#{error_desc}) " \
        if duplicates.any?

      courts_involved = ts_schedule.map { |game| game[2] }.flatten
      duplicates = courts_involved.select { |court| courts_involved.count(court) > 1 }.uniq
      return "#{pluralize(duplicates.count, 'Court')} #{duplicates.join(', ')} used at the same time during different games(#{error_desc}) " \
        if duplicates.any?
    }
    nil
  end


end