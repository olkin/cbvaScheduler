class TierSettingsController < ApplicationController
  before_action :set_tier_setting, only: [:show, :edit, :update, :destroy]

  # GET /tier_settings
  # GET /tier_settings.json
  def index
    @tier_settings = TierSetting.all
  end

  # GET /tier_settings/1
  # GET /tier_settings/1.json
  def show
  end

  # GET /tier_settings/new
  def new
    @tier_setting = TierSetting.new
  end

  # GET /tier_settings/1/edit
  def edit
  end

  # POST /tier_settings
  # POST /tier_settings.json
  def create
    @tier_setting = TierSetting.new(tier_setting_params)

    respond_to do |format|
      if @tier_setting.save
        format.html { redirect_to @tier_setting, notice: 'Tier setting was successfully created.' }
        format.json { render :show, status: :created, location: @tier_setting }
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
        format.html { redirect_to @tier_setting, notice: 'Tier setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @tier_setting }
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
      format.html { redirect_to tier_settings_url, notice: 'Tier setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tier_setting
      @tier_setting = TierSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tier_setting_params
      params.require(:tier_setting).permit(:league_id, :tier, :total_teams, :teams_down, :schedule_pattern, :day)
    end
end
