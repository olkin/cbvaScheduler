class TierSettingsController < ApplicationController
  before_action :set_league, only: [:new, :index, :create]
  before_action :set_tier_setting, only: [:edit, :update, :destroy]

  # GET /tier_settings
  # GET /tier_settings.json
  def index
    @tier_settings = @league.tier_settings.order(:tier)
  end

  # GET /tier_settings/new
  def new
    settings_week = @league.weeks.find_by_week(nil)
    settings = settings_week ? settings_week[:settings] : []

    no_setting_tier = settings.index{|setting| setting == nil}
    default_tier = (no_setting_tier || settings.size) + 1
    #TODO: get default day from next available tier?
    default_day = settings[default_tier - 1][:day] if settings[default_tier - 1]

    @tier_setting = TierSetting.new(total_teams: 2, teams_down: 0, tier: default_tier, day: default_day)
  end

  # GET /tier_settings/1/edit
  def edit
  end

  # POST /tier_settings
  # POST /tier_settings.json
  def create
    @tier_setting = @league.tier_settings.build(tier_setting_params)

    respond_to do |format|
      if @tier_setting.save
        format.html { redirect_to league_tier_settings_url, notice: 'Tier setting was successfully created.' }
        format.json { render :index, status: :created, location: @tier_setting }
      else
        format.html { render :new }
        format.json { render json: @tier_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tier_settings/1
  # PATCH/PUT /tier_settings/1.json
  def update
    respond_to do |format|
      if @tier_setting.update(tier_setting_params)
        format.html { redirect_to league_tier_settings_url(@tier_setting.league), notice: 'Tier setting was successfully updated.' }
        format.json { render :index, status: :ok, location: @tier_setting }
      else
        format.html { render :edit }
        format.json { render json: @tier_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tier_settings/1
  # DELETE /tier_settings/1.json
  def destroy
    @tier_setting.destroy
    respond_to do |format|
      format.html { redirect_to league_tier_settings_url(@tier_setting.league), notice: 'Tier setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tier_setting
      @tier_setting = TierSetting.find(params[:id])
    end

    def set_league
      @league = League.find(params[:league_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tier_setting_params
      params.require(:tier_setting).permit(:tier, :total_teams, :teams_down, :schedule_pattern, :day)
    end
end
