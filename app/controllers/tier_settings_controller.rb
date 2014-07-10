class TierSettingsController < ApplicationController
  before_action :set_week, only: [:new, :create, :index]
  before_action :set_tier_setting, only: [:show, :edit, :update, :destroy]

  # GET /tier_settings
  # GET /tier_settings.json
  def index
    @tier_settings = @week.tier_settings.all
  end

  # GET /tier_settings/1
  # GET /tier_settings/1.json
  def show
  end

  # GET /tier_settings/new
  def new
    all_tiers = @week.tier_settings.all.map{|setting| setting[:tier]}.uniq.sort
    missing_tiers = (1..all_tiers.size).to_a - all_tiers
    default_tier = missing_tiers[0] || all_tiers.size + 1
    @tier_setting = TierSetting.new(tier: default_tier)
  end

  # GET /tier_settings/1/edit
  def edit
  end

  # POST /tier_settings
  # POST /tier_settings.json
  def create
    @tier_setting = @week.tier_settings.build(tier_setting_params)

    respond_to do |format|
      if @tier_setting.save
        format.html { redirect_to @tier_setting.week, notice: 'Tier setting was successfully created.' }
        format.json { render :show, status: :created, location: week }
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
        format.html { redirect_to @tier_setting.week, notice: 'Tier setting was successfully updated.' }
        format.json { render :show, status: :ok, location: week }
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
      format.html { redirect_to @tier_setting.week, notice: 'Tier setting was successfully destroyed.' }
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
      tier_params = params.require(:tier_setting).permit(:week_id, :tier, :total_teams, :teams_down, :day)
      #work-around to accept array of arrays
      tier_params[:schedule_pattern] = params[:tier_setting][:schedule_pattern] if params[:tier_setting][:schedule_pattern]
      tier_params
    end

    def set_week
        @week = Week.find(params[:week_id])
    end
end
