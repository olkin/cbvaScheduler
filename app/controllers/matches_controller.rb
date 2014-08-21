class MatchesController < ApplicationController

  def show
    @match = Match.find(params[:id])
  end

  # PATCH/PUT /standings/1
  def update
    @match = Match.find(params[:id])

    if @match.update(score_params)
      redirect_to week_path(@match.week), notice: "Match #{@match.team1.name} vs #{@match.team2.name} was updated with score #{@match.score_line}"
    else
      render :show
    end

  end

  private

  def score_params
    #TODO: don't know yet how to make a virtual attribute as array/hash
    begin
      result = []
      params[:score].each_value {|game_scores|
        game_score = []
        game_scores.each_value { |team_score|
          game_score << (team_score.to_i unless team_score.blank?)
        }

        result << (game_score unless game_score.compact.empty?)
      }

      #drop the last nils
      result = result.reverse.drop_while{|x| x.nil?}.reverse

    rescue
      result = params[:score]
    end


    {score: result}
  end

end
