class StandingsController < ApplicationController
  before_action :set_week, only: [:new, :create]
  before_action :set_standing, only: [:show, :edit, :update, :destroy]

  # GET /standings/1
  def show
  end

  # GET /standings/new
  def new
    @standing = @week.standings.new
    @standing.build_team
  end

  # GET /standings/1/edit
  def edit
  end

  # POST /standings
  def create
    @standing = @week.standings.build(standing_params)
    if @standing.save
      redirect_to @week, notice: "#{@standing.team.name} was successfully added to registration."
    else
      render :new
    end

  end

  # PATCH/PUT /standings/1
  def update
    if @standing.update(standing_params)
      redirect_to @standing.week, notice: "Standings for #{@standing.team.name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /standings/1
  def destroy
    @standing.destroy
    redirect_to @standing.week, notice: "#{@standing.team.name} was successfully removed from registration"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_standing
    @standing = Standing.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def standing_params
    params.require(:standing).permit(:week_id, :tier, :rank, :team_id, team_attributes: [:id, :name, :captain, :email, :league_id])
  end

  def set_week
    @week = Week.find(params[:week_id])
  end
end
