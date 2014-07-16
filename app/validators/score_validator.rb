class ScoreValidator < ActiveModel::Validator
  MIN_SCORE_SET_SUM = 0

  def validate(record)
    return true if record[:score].nil? or record[:score].blank?

    add_error = Proc.new {|error_msg|
      record.errors[:score] << error_msg
      return
    }

    max_nr_of_sets = eval(record.team1_standing.tier_setting.set_points).size
    record.errors[:score] << "Wrong format of score" unless record[:score].is_a?Array and record[:score].any?
    scores = record[:score]
    add_error["More than #{max_nr_of_sets} sets is reported"] if scores.size > max_nr_of_sets
    team1_wins, team2_wins = 0, 0
    scores.each_with_index{ |game_score, idx|
      error_desc = "game #{idx + 1} : #{game_score}"

      add_error["Wrong format of score #{error_desc}"] unless game_score.is_a?Array

      score1, score2 = game_score
      add_error["Score for a team not specified #{error_desc}"] unless score1 and score2
      add_error["Score for a team wrong format #{error_desc}"] unless score1.is_a?Fixnum and score2.is_a?Fixnum

      add_error["Scores should be >=0 #{error_desc}"] unless score1 >= 0 and score2 >= 0
      add_error["Scores can't be equal #{error_desc}"] if score1 == score2 and score1 != 0

      add_error["Scores sum should be >= #{MIN_SCORE_SET_SUM} #{error_desc}"] if score1 + score2 < MIN_SCORE_SET_SUM

      max_score_set = eval(record.team1_standing.tier_setting.set_points)[idx]
      puts "Max score: #{max_score_set}"
      add_error["Scores should be <= #{max_score_set} #{error_desc}"]  if [score1, score2].max > max_score_set \
        and (score1 - score2).abs > 2

      if idx > 0
        add_error["Set #{idx} is not completed #{scores.to_s}"] if scores[0].max < max_score_set

        sets_to_play = max_nr_of_sets - (team1_wins + team2_wins)
        if team1_wins != team2_wins and sets_to_play > 0
          add_error["Set#{idx + 1} is redundant"] \
            if [team1_wins, team2_wins].min + sets_to_play < [team1_wins, team2_wins].max
        end
      end

      team1_wins += 1 if game_score.max == game_score[0]
      team2_wins += 1 if game_score.max == game_score[1]
    }

    true
  end
end