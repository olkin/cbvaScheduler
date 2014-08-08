class MatchesController < ApplicationController

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    @match = Match.find(params[:id])

    if @match.update(match_params)
      @match.week.standings.all.find_by(team_id: @match.team1).update_stats
      @match.week.standings.all.find_by(team_id: @match.team2).update_stats
      redirect_to @match.league, notice: "Match game ##{@match.game} court ##{@match.court} was successfully updated."
    else
      redirect_to @match.league, notice: "Match game ##{@match.game} court ##{@match.court}  was NOT updated."
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def match_params
    match_params = params.require(:match).permit(:team1_id, :team2_id, :score, :court)
    match_params[:score] = match_params[:score].scan(/(\d+)[:-](\d+)/).map { |x, y| [x.to_i, y.to_i] } if match_params[:score]
    match_params
  end
end
