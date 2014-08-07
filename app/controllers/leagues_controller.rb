class LeaguesController < ApplicationController
  before_action :set_league_type, only: [:show, :edit, :update, :destroy]

  # GET /leagues
  # GET /leagues.json
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  # GET /leagues/1.json
  def show
    redirect_to league_weeks_path(@league)
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  # POST /leagues.json
  def create
    @league = League.new(league_type_params)
    if @league.save
      redirect_to leagues_url, notice: "Event #{@league.description} was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /leagues/1
  # PATCH/PUT /leagues/1.json
  def update
    if @league.update(league_type_params)
      redirect_to leagues_url, notice: "Event #{@league.description} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /leagues/1
  # DELETE /leagues/1.json
  def destroy
    @league.destroy
    redirect_to leagues_url, notice: "Event #{@league.description} was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_league_type
    @league = League.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def league_type_params
    params.require(:league).permit(:desc, :description, :start_date)
  end
end
