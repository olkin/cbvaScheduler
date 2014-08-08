class TierSettingsController < ApplicationController
  before_action :set_week, only: [:new, :create]
  before_action :set_tier_setting, only: [:edit, :update, :destroy]

  # GET /tier_settings/new
  def new
    @tier_setting = TierSetting.new(tier: @week.next_missing_tier)
  end

  # GET /tier_settings/1/edit
  def edit
  end

  # POST /tier_settings
  # POST /tier_settings.json
  def create
    @tier_setting = @week.tier_settings.build(tier_setting_params)

    if @tier_setting.save
      redirect_to @tier_setting.week, notice: "Settings for tier ##{@tier_setting.tier} were added successfully."
    else
      render :new
    end
  end

  # PATCH/PUT /tier_settings/1
  # PATCH/PUT /tier_settings/1.json
  def update
    if @tier_setting.update(tier_setting_params)
      redirect_to @tier_setting.week, notice: "Settings for tier ##{@tier_setting.tier} were successfully updated."
    else
      render :edit
    end
  end

  # DELETE /tier_settings/1
  # DELETE /tier_settings/1.json
  def destroy
    @tier_setting.destroy
    redirect_to @tier_setting.week, notice: "Settings for tier ##{@tier_setting.tier} were successfully removed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tier_setting
    @tier_setting = TierSetting.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tier_setting_params
    tier_params = params.require(:tier_setting).permit(:week_id, :tier, :total_teams, :teams_down, :day, :cycle, :set_points, :match_times, :name)
    #work-around to accept array of arrays
    tier_params[:schedule_pattern] = params[:tier_setting][:schedule_pattern] if params[:tier_setting][:schedule_pattern]
    tier_params
  end

  def set_week
    @week = Week.find(params[:week_id])
  end
end
