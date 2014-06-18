class ScoreValidator < ActiveModel::Validator
  MAX_NR_OF_SETS = 3
  MAX_POINTS_FOR_SET = 21
  TOTAL_POINTS_MATCH = 6
  MAX_SCORE_SET = 21
  MIN_SCORE_SET_SUM = 8

  def validate(record)
    return true if record[:score].nil?

    add_error = Proc.new {|error_msg|
      record.errors[:score] << error_msg
      return
    }

    record.errors[:score] << "Wrong format of score" unless record[:score].is_a?Array and record[:score].any?
    scores = record[:score]
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

      add_error["Scores should be <= #{MAX_SCORE_SET} #{error_desc}"]  if [score1, score2].max > MAX_SCORE_SET \
        and (score1 - score2).abs > 2

      if idx > 0
        add_error["Set #{idx} is not completed #{scores.to_s}"] if scores[0].max < MAX_POINTS_FOR_SET
        add_error["More than #{MAX_NR_OF_SETS} is reported"] if idx >= MAX_NR_OF_SETS

        sets_to_play = MAX_NR_OF_SETS - (team1_wins + team2_wins)
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