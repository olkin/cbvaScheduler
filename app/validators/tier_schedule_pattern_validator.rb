class TierSchedulePatternValidator < ActiveModel::Validator
  MAX_GAMES_PER_DAY = 4
  MAX_BYES = 1
  GAME_SCH_MEMBERS_COUNT = 3
  MAX_COURTS = 12

  def validate(record)
    add_error = Proc.new {
      |error_msg| record.errors[:schedule_pattern] << error_msg
      return
    }

    #Check out format first
    schedule_pattern = record.schedule_pattern
    add_error["Invalid format of cycles or empty"] unless schedule_pattern.is_a?Array and schedule_pattern.any?

    schedule_pattern.each_with_index { |cycle_schedule, idx|
      error_desc = "cycle # #{idx + 1}"
      add_error["Invalid format for #{error_desc}"] unless cycle_schedule.is_a?Array
      add_error["Invalid number of timeslots(#{cycle_schedule.size}) for #{error_desc} "] \
        unless cycle_schedule.size.between?(MAX_GAMES_PER_DAY - MAX_BYES, MAX_GAMES_PER_DAY)

      cycle_schedule.each_with_index { |timeslot_schedule, timeslot_idx |
        error_desc = "game ##{timeslot_idx + 1}[#{idx + 1}]"
        add_error["Invalid format for #{error_desc}"] \
          unless timeslot_schedule.is_a?Array

        timeslot_schedule.each { |game_schedule|
          add_error["Invalid format for #{error_desc}: #{game_schedule.to_s}"] \
            unless game_schedule.is_a?Array and game_schedule.size == GAME_SCH_MEMBERS_COUNT

          team1, team2, court = game_schedule
          add_error["Invalid format for team for #{error_desc}: #{game_schedule.to_s}"] \
            unless team1.is_a?Fixnum and team1 > 0 and team2.is_a?Fixnum and team2 > 0

          add_error["Team #{team1} plays itself for #{error_desc}"] if team1 == team2

          add_error["Court #{court} is invalid for #{error_desc}"] \
            unless court.is_a?Fixnum and court.between?(1, MAX_COURTS)
        }
      }
    }

    # check out that same team/court is not played/used at the same time
    schedule_pattern.each_with_index { |cycle_schedule, idx|
      ranks_involved = cycle_schedule.map {|ts_schedule| ts_schedule.inject([]){|teams, game| teams + [game[0], game[1]]}}
      courts_involved = cycle_schedule.map {|ts_schedule| ts_schedule.inject([]){|teams, game| teams + [game[2]]}}

      find_ts_duplicates = Proc.new {
          |ts_array| ts_array.map.with_index{
            |items,ts| [items.select{|item| items.count(item)>1}.uniq, ts] \
              if items.uniq.size != items.size}.compact
      }

      dup_ranks_ts =  find_ts_duplicates.call ranks_involved
      dup_courts_ts = find_ts_duplicates.call courts_involved

      dup_desc = Proc.new { |ts_array, item_str|
        descriptions = ts_array.map{|items, game| "game #{game+1}: #{pluralize(items.count, item_str)} #{items.join(', ')}"}
        descriptions.any? ? "Duplicates: #{descriptions.join(', ')}" : "No duplicates"
      }

      add_error[dup_desc.call dup_ranks_ts, 'team'] if dup_ranks_ts.any?
      add_error[dup_desc.call dup_courts_ts, 'court'] if dup_courts_ts.any?

      teams_played = ranks_involved.flatten
      not_enough_games_teams = teams_played.select{|rank| !teams_played.count(rank).between?(1, MAX_GAMES_PER_DAY - MAX_BYES)}.uniq
      add_error["#{'Team'.pluralize(not_enough_games_teams.size)} #{not_enough_games_teams.join(', ')} didn't get enough games"] if not_enough_games_teams.any?

      if record.errors[:total_teams].empty?
        teams = Array(1..record.total_teams)

        missing_teams = teams - teams_played
        add_error["No games for #{'team'.pluralize(missing_teams.size)} #{missing_teams.join(',')}"] if missing_teams.any?

        extra_teams = teams_played - teams
        add_error["Schedule for extra #{'team'.pluralize(extra_teams.size)} #{extra_teams.join(',')}"] if extra_teams.any?
      end
    }
  end
end