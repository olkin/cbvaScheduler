class WeeksController < ApplicationController
  before_action :set_week, only: [:destroy, :show, :save_settings]
  #before_action :authenticate, except: [:index, :show]


  def index
    @league = League.find(params[:league_id])
    @league.weeks.create if @league.weeks.empty?
    @week = @league.weeks.first
    render :show
  end

  def show
    @week.valid?
  end

  def destroy
    error_reason = 'No admin rights' unless admin?
    # TODO: can only remove the last week
    # TODO: on destroy settings week should be updated
    # TODO: destroy from league?

    if error_reason
      redirect_to @week, notice: "#{@week.name} cannot be destroyed (#{error_reason})"
    else
      @week.destroy
      redirect_to league_url(@week.league), notice: "#{@week.name} was successfully destroyed."
    end
  end

=begin
  def save_settings
    error_reason = 'No admin rights' unless admin?
    error_reason ||= ('Not a setting week' unless @week.setting?)
    error_reason ||= ('Can\'t supply invalid week' unless @week.valid?)
    error_reason ||= ('Error during submitting settings' unless @week.submit_settings)

    if error_reason
      redirect_to @week, notice: "#{@week.name} cannot be changed (#{error_reason})"
    else
      redirect_to league_url(@week.league), notice: 'Settings has been changed. Schedule is updated.'
    end
  end
=end

  private

  def set_week
    @week = Week.find(params[:id])
  end

end
