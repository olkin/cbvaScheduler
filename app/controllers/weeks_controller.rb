class WeeksController < ApplicationController
  before_action :set_league
  before_action :set_week
  before_action :set_week_settings

  def index
  end

  def new_tier
    default_day = @settings[-1][:day] if @settings and @settings[-1]
    @defaults = {total_teams: 2, teams_down: 0, day: default_day}
  end

  def create_tier
    if params[:tier]
      tier = params[:tier].to_i
      puts "ERRORRRRR" if tier.to_i >= @settings.size
    else
      tier = @settings.size
    end

    @settings[tier] = tier_setting_params

    @week.update_attribute(:settings, @settings)

    respond_to do |format|
      format.html { redirect_to league_weeks_path(@league), notice: 'Tier setting was successfully created.' }
      format.json { render :index, status: :created, location: @week }
    end
  end

  def edit_tier
    tier = params[:tier].to_i
    @defaults = @settings[tier]
  end

  def destroy_tier
    tier = params[:tier]

    if tier
      @settings.delete_at(tier.to_i)
      @week.update_attribute(:settings, @settings)
    end

    respond_to do |format|
      format.html { redirect_to league_weeks_path(@league), notice: "Tier setting was successfully removed." }
      format.json { render :index, status: :created, location: @week }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def tier_setting_params
      params.permit(:total_teams, :teams_down, :schedule_pattern, :day)
    end

    def set_league
      @league = League.find(params[:league_id])
    end

    def set_week
      @week = @league.weeks.find_by_week(nil)
    end

    def set_week_settings
      @settings = @week[:settings] || []
    end
end
