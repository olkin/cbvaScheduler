class StandingsController < ApplicationController
  before_action :set_week, only: [:new, :create, :index]
  before_action :set_standing, only: [:show, :edit, :update, :destroy]

  # GET /tier_settings
  # GET /tier_settings.json
  def index
    @standings = @week.standings.all
  end

  # GET /tier_settings/1
  # GET /tier_settings/1.json
  def show
  end

  # GET /tier_settings/new
  def new
    @standing = Standing.new
  end

  # GET /tier_settings/1/edit
  def edit
  end

  # POST /tier_settings
  # POST /tier_settings.json
  def create
    @standing = @week.standings.build(standing_params)

    respond_to do |format|
      if @standing.save
        format.html { redirect_to week_standings_url(@week), notice: 'STanding setting was successfully created.' }
        format.json { render :show, status: :created, location: @standing }
      else
        format.html { render :new }
        format.json { render json: @standing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tier_settings/1
  # PATCH/PUT /tier_settings/1.json
  def update
    respond_to do |format|
      if @standing.update(standing_params)
        format.html { redirect_to @standing, notice: 'Standing setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @standing }
      else
        format.html { render :edit }
        format.json { render json: @standing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tier_settings/1
  # DELETE /tier_settings/1.json
  def destroy
    @standing.destroy
    respond_to do |format|
      format.html { redirect_to week_standings_url(@standing.week), notice: 'Standing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_standing
    @standing = Standing.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def standing_params
    params.require(:standing).permit(:week_id, :tier, :rank, :team_id)
  end

  def set_week
    @week = Week.find(params[:week_id])
  end
end
