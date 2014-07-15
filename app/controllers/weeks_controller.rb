class WeeksController < ApplicationController
  before_action :set_league, only: [:create, :index, :new]
  before_action :set_week, only: [:edit, :update, :destroy, :show, :save_settings]

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
    @standings = @week.standings.order("tier, rank")
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

  def save_settings
    if @week.week == nil and @week.save
      #update week details
      cur_week_nr = @week.league.weeks.maximum("week") || 0
      @week.league.weeks.where(week: cur_week_nr).destroy_all
      cur_week = @week.dup
      cur_week.week = cur_week_nr
      cur_week.save

      #update standings
      new_standings = @week.standings.all.sort_by { |standing| [standing[:tier], standing[:rank]]}
      @week.standings.update_all(rank: nil)
      rank = 0
      @week.tier_settings.all.order(:tier).each { |setting|
        tier = setting[:tier]
        setting[:total_teams].times{
          break unless new_standings[rank]
          setting_standing = @week.standings.find_by_team_id(new_standings[rank][:team_id])
          setting_standing.tier = tier
          setting_standing.rank = rank + 1
          setting_standing.save

          #setting_standing.save
          new_standing = setting_standing.dup
          new_standing.week_id = cur_week.id
          new_standing.save
          rank += 1
        }
      }

      #update schedule after standings are done
      team_offset = 0
      standings = @week.standings
      @week.tier_settings.all.order(:tier).each { |setting|
        cycles_schedule = eval(setting.schedule_pattern)
        cycle = setting.cycle
        if !(cycle and cycle.between?(1, cycles_schedule.size))
          cycle = 1
          #setting = @week.tier_settings.find_by_tier(setting[:tier])
          setting.cycle = 1
          setting.save
        end

        schedule = cycles_schedule[cycle - 1]

        schedule.each_with_index { |ts_schedule, game_idx|
          ts_schedule.each { |game|
            team1 = standings.find_by_rank(game[0].to_i + team_offset).team_id
            team2 = standings.find_by_rank(game[1].to_i + team_offset).team_id
            court = game[2]
            puts "Game #{game_idx + 1}: #{team1} vs #{team2} on #{court}"
            new_match = cur_week.matches.create(team1_id: team1, team2_id: team2, court: court, game: game_idx + 1)
            new_match.save
          }
        }



        team_offset += setting[:total_teams]
      }


      respond_to do |format|
        format.html { redirect_to @week.league, notice: "Almost saved #{cur_week_nr}" }
        format.json { render :show, location: @week }
      end
    else
      respond_to do |format|
        format.html { redirect_to @week, notice: "Week can't be saved" }
        format.json { render :show, location: @week }
      end

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
