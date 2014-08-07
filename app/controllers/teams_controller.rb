class TeamsController < ApplicationController
  before_action :set_league, only: [:new, :create, :index]
  before_action :set_team, only: [:edit, :update, :destroy]


  # GET /teams
  # GET /teams.json
  def index
    if @league
      @teams = @league.teams.all
    else
      @teams = Team.search(params[:search])
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = @league.teams.build(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to league_teams_url, notice: "Team #{@team.name} was successfully created." }
        format.json { render :index, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to league_teams_url(@team.league), notice: "Team #{@team.name} was successfully updated." }
        format.json { render :index, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to league_teams_url(@team.league), notice: "Team #{@team.name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      if @league
        @team = @league.teams.find(params[:id])
      else
        @team = Team.find(params[:id])
      end
    end

    def set_league
      @league = League.find(params[:league_id]) if params[:league_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :captain, :email)
    end
end
