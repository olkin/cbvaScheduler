require 'json'

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

    begin
      schedule_pattern = JSON.parse(record[:schedule_pattern])
    rescue JSON::ParserError => exc
      puts exc.message
      add_error["Invalid format"]
    end

    #Check out format first
    add_error["Invalid format of cycles or empty"] unless schedule_pattern.is_a?Array and schedule_pattern.any?

    schedule_pattern.each_with_index { |cycle_schedule, idx|
      error_desc = "cycle # #{idx + 1}"
      add_error["Invalid format for #{error_desc}"] unless cycle_schedule.is_a?Array
      add_error["Invalid number of timeslots(#{cycle_schedule.size}) for #{error_desc} "] \
        unless cycle_schedule.size.between?(MAX_GAMES_PER_DAY - MAX_BYES, MAX_GAMES_PER_DAY)

      cycle_schedule.each_with_index { |timeslot_schedule, timeslot_idx |
        error_desc = "game ##{timeslot_idx + 1}[#{idx + 1}]"
        add_error["Invalid format for #{error_desc}"] \
          unless timeslot_schedule.is_a?Array and timeslot_schedule.any?

        timeslot_schedule.each { |game_schedule|
          add_error["Invalid format for #{error_desc}: #{game_schedule.to_s}"] \
            unless game_schedule.is_a?Array and game_schedule.size == GAME_SCH_MEMBERS_COUNT
        }
      }
    }

    # get all played teams
    ranks_involved = Array.new
    courts_involved = Array.new
    schedule_pattern.each_with_index { |cycle_schedule, idx|
      cycle_schedule.each_with_index { |timeslot_schedule, timeslot_idx |
        timeslot_schedule.each { |game_schedule|
          ranks_involved += [game_schedule[0].to_i, game_schedule[1].to_i]
          courts_involved += [game_schedule[2].to_i]
        }
      }
    }

    ranks_involved.uniq!
    teams = Array(1..record[:total_teams])

    missing_teams = teams - ranks_involved
    add_error["No games for #{'team'.pluralize(missing_teams.size)} #{missing_teams.join(',')}"] if missing_teams.any?

    extra_teams = ranks_involved - teams
    add_error["Schedule for extra #{'team'.pluralize(extra_teams.size)} #{extra_teams.join(',')}"] if extra_teams.any?

    courts_involved.uniq!
    available_courts = Array(1..MAX_COURTS)
    extra_courts = courts_involved - available_courts
    add_error["Unknown #{'court'.pluralize(extra_courts.size())} #{extra_courts.join(', ')}"] if extra_courts.any?


    # check out that same team/court is not played/used at the same time
    schedule_pattern.each_with_index { |cycle_schedule, idx|
      cycle_schedule.each_with_index { |timeslot_schedule, timeslot_idx |
        courts_used = []
        teams_involved = []
        timeslot_schedule.each { |game_schedule|
          teams_involved += [game_schedule[0], game_schedule[1]]
          courts_used += [game_schedule[2]]
        }

      repeated_courts = courts_used.dup
      repeated_courts.keep_if{|court| courts_used.count(court) > 1}
      repeated_courts.uniq!

      error_desc = "game ##{timeslot_idx + 1}[#{idx + 1}]"
      add_error["#{'Court'.pluralize(repeated_courts.size)} #{repeated_courts.join(',')} used more than once for #{error_desc}"] \
        if repeated_courts.any?

      repeated_ranks = teams_involved.dup
      repeated_ranks.keep_if{|rank| repeated_ranks.count(rank) > 1}
      repeated_ranks.uniq!
      add_error["#{'Team'.pluralize(repeated_ranks.size)} #{repeated_ranks.join(', ')} used more than once for #{error_desc}"] \
        if repeated_ranks.any?
      }
    }

  end
end