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
    params.require(:match).permit(:score_line)
  end

end