class WeeksController < ApplicationController
  before_action :set_league, only: [:create, :index, :new]
  before_action :set_week, only: [:edit, :update, :destroy, :show]

  def index
    setting_week = @league.weeks.find_or_create_by(week: nil)
    respond_to do |format|
      format.html { redirect_to week_path(setting_week) }
      format.json { render :show, location: setting_week }
    end
  end

  def new
    @week = Week.new
  end

  def edit
  end

  def show
    @week.save
    @tier_settings = @week.tier_settings.order("tier")
    @standings = @week.standings.order("tier")
  end

  def create
    @week = @league.weeks.build(week_params)

    respond_to do |format|
      if @week.save
        format.html { redirect_to league_weeks_url, notice: "New week #{@week.week} was successfully created." }
        format.json { render :index, status: :created, location: @week }
      else
        format.html { render :new }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @week.update(week_params)
        format.html { redirect_to league_weeks_url(@week.league), notice: "Week #{@week.week} was successfully updated." }
        format.json { render :index, status: :ok, location: @week }
      else
        format.html { render :edit }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @week.destroy
    respond_to do |format|
      format.html { redirect_to league_weeks_url(@week.league), notice: "Week #{@week.week} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_week
    @week = Week.find(params[:id])
  end

  def set_league
    @league = League.find(params[:league_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def week_params
    (params.require(:week).permit(:week, :cycle) if params[:week]  and params[:week].any?) || {}
  end
end
