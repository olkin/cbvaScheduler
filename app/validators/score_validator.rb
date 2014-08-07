class ScoreValidator < ActiveModel::Validator
  MIN_SCORE_SET_SUM = 8 #TODO: should be a config file with the option
  #TODO: capped option should be in config too

  def validate(record)
    return true if record.score.blank?

    return if record.errors.any?

    add_error = Proc.new {|error_msg|
      record.errors[:score] << error_msg
      return
    }

    scores = record[:score]
    format_error = validate_format scores
    add_error[format_error] if format_error

    set_points = record.tier_setting.set_points
    max_nr_of_sets = set_points.size
    add_error["More than #{max_nr_of_sets} #{'set'.pluralize(max_nr_of_sets)} is reported"] if scores.size > max_nr_of_sets

    game_logic_error = validate_game_logic scores, set_points
    add_error[game_logic_error] if game_logic_error

    match_logic_error = validate_match_logic scores, set_points
    add_error[match_logic_error] if match_logic_error

    true
  end

  private
  def validate_format(scores)
    return 'Scores should be supplied as array' unless scores.is_a? Array
    return 'At least 1 set score should be provided' unless scores.any?

    scores.each_with_index { |game_score, idx|
      error_desc = "game #{idx + 1} : #{game_score}"
      return "Invalid format for #{error_desc}" unless game_score.is_a? Array
      #TODO: accumuulate
    }

    scores.each_with_index { |game_score, idx|
      error_desc = "game #{idx + 1} : #{game_score}"

      score1, score2 = game_score
      return "Score for team #{score1 ? '2' : '1'} not specified #{error_desc}" unless score1 and score2
      return "Scores should be numbers #{error_desc}" unless score1.is_a? Fixnum and score2.is_a? Fixnum
      return "Scores should be >=0 #{error_desc}" unless score1 >= 0 and score2 >= 0
    }
    nil
  end

  def validate_game_logic(scores, set_points)
    scores.each_with_index { |game_score, idx|
      error_desc = "game #{idx + 1} : #{game_score}"

      score1, score2 = game_score

      unless score1 == score2 and score1 == 0
        return "Scores can't be equal #{error_desc}(unless both default)" if score1 == score2
        return "Scores sum should be >= #{MIN_SCORE_SET_SUM} #{error_desc}" if score1 + score2 < MIN_SCORE_SET_SUM
      end

      game_max_score = set_points[idx]
      return "Scores should be <= #{game_max_score} #{error_desc}" if [score1, score2].max > game_max_score \
        and (score1 - score2).abs > 2
    }
    nil
  end

  def validate_match_logic(scores, set_points)
    max_nr_of_sets = set_points.size

    team1_wins, team2_wins = 0, 0
    scores.each_with_index { |game_score, idx|
      if idx > 0
        game_max_score = set_points[idx]
        return "Set #{idx} is not completed #{scores.to_s}" if scores[0].max < game_max_score

        sets_to_play = max_nr_of_sets - (team1_wins + team2_wins)
        #TODO: configurable? what if teams play as many sets as time permits? - Answer: supply more played sets in settings
        if team1_wins != team2_wins and sets_to_play > 0
          return "Set#{idx + 1} is redundant" \
            if [team1_wins, team2_wins].min + sets_to_play < [team1_wins, team2_wins].max
        end
      end

      team1_wins += 1 if game_score.max == game_score[0]
      team2_wins += 1 if game_score.max == game_score[1]
    }
    nil
  end
end