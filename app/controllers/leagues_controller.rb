class LeaguesController < ApplicationController
  before_action :set_league_type, only: [:show, :edit, :update, :destroy]

  # GET /Leagues
  # GET /Leagues.json
  def index
    @leagues = League.all
  end

  # GET /Leagues/1
  # GET /Leagues/1.json
  def show
    @teams = @league.teams
  end

  # GET /Leagues/new
  def new
    @league = League.new
  end

  # GET /Leagues/1/edit
  def edit
  end

  # POST /Leagues
  # POST /Leagues.json
  def create
    @league = League.new(league_type_params)

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League type was successfully created.' }
        format.json { render :show, status: :created, location: @league }
      else
        format.html { render :new }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Leagues/1
  # PATCH/PUT /Leagues/1.json
  def update
    respond_to do |format|
      if @league.update(league_type_params)
        format.html { redirect_to @league, notice: 'League type was successfully updated.' }
        format.json { render :show, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Leagues/1
  # DELETE /Leagues/1.json
  def destroy
    @league.destroy
    respond_to do |format|
      format.html { redirect_to leagues_url, notice: 'League type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league_type
      @league = League.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_type_params
      league_params = params.require(:league).permit(:desc, :description)
      league_params["start_date"] =  Date.new(params[:start_date][:year].to_i,
                                           params[:start_date][:month].to_i,
                                           params[:start_date][:day].to_i).to_s if params[:start_date]
      league_params
    end
end
