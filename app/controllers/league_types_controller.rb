class LeagueTypesController < ApplicationController
  before_action :set_league_type, only: [:show, :edit, :update, :destroy]

  # GET /league_types
  # GET /league_types.json
  def index
    @league_types = LeagueType.all
  end

  # GET /league_types/1
  # GET /league_types/1.json
  def show
  end

  # GET /league_types/new
  def new
    @league_type = LeagueType.new
  end

  # GET /league_types/1/edit
  def edit
  end

  # POST /league_types
  # POST /league_types.json
  def create
    @league_type = LeagueType.new(league_type_params)

    respond_to do |format|
      if @league_type.save
        format.html { redirect_to @league_type, notice: 'League type was successfully created.' }
        format.json { render :show, status: :created, location: @league_type }
      else
        format.html { render :new }
        format.json { render json: @league_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /league_types/1
  # PATCH/PUT /league_types/1.json
  def update
    respond_to do |format|
      if @league_type.update(league_type_params)
        format.html { redirect_to @league_type, notice: 'League type was successfully updated.' }
        format.json { render :show, status: :ok, location: @league_type }
      else
        format.html { render :edit }
        format.json { render json: @league_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /league_types/1
  # DELETE /league_types/1.json
  def destroy
    @league_type.destroy
    respond_to do |format|
      format.html { redirect_to league_types_url, notice: 'League type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league_type
      @league_type = LeagueType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def league_type_params
      params.require(:league_type).permit(:desc, :description)
    end
end
