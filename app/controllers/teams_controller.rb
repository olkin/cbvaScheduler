class TeamsController < ApplicationController
  before_action :set_league, only: [:new, :create, :index]
  before_action :set_team, only: [:edit, :update, :destroy, :show]


  # GET /teams
  # GET /teams.json
  def index
    if params[:search]
      @teams = Team.search(params[:search])
    else
      @teams = @league.teams.all
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  def show
    cur_week = @team.league.cur_week
    cur_standing = cur_week.standings.find_by(team_id: @team.id) if cur_week
    if cur_standing
      redirect_to standing_path(cur_standing)
    else
      render :show
    end
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = @league.teams.build(team_params)

    if @team.save
      redirect_to league_teams_url, notice: "Team #{@team.name} was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if @team.update(team_params)
      redirect_to league_teams_url(@team.league), notice: "Team #{@team.name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    redirect_to league_teams_url(@team.league), notice: "Team #{@team.name} was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  def set_league
    @league = League.find(params[:league_id]) if params[:league_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :captain, :email)
  end
end
