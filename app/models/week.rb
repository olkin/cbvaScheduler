class Week < ActiveRecord::Base
  default_scope { order('week DESC') }
  belongs_to :league
  has_many :tier_settings, dependent: :destroy
  has_many :standings, dependent:  :destroy
  has_many :matches, through: :standings, source: :matches1

  validates :week, numericality:{ greater_than_or_equal_to: 0, only_integer: true}, allow_nil: true
  validates_uniqueness_of :week, scope: :league

  validates_with RegistrationValidator
  validates_with WeekSettingsValidator
  validates_with StandingsValidator

  def name
    self.week ? "Week #{self.week + 1}" : 'Settings'
  end

=begin
  def update_stats
    self.standings.each {|standing| standing.reset_stats}
  end
=end

  def next_missing_tier
    all_tiers = self.tier_settings.all.map { |setting| setting[:tier] }.uniq.sort
    missing_tiers = (1..all_tiers.size).to_a - all_tiers
    missing_tiers[0] || all_tiers.size + 1
  end

  def submit_settings
=begin
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

      new_setting = setting.dup
      new_setting.week_id = cur_week.id
      new_setting.save

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
=end
  end

  def setting?
    self.week.nil?
  end
end
