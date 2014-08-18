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

  def submit
    if self.setting?
      submit_settings if valid?
    else
      submit_results
    end
  end

  def setting?
    self.week.nil?
  end

  private
  def submit_settings
    cur_week_nr = self.league.cur_week.week || 0

    duplicate_settings cur_week_nr

    generate_schedule cur_week_nr

    true
  end


  def submit_results
    return false unless self.week

    # update stats

    # rerank based on results

    # duplicate settings of this week to setting week

    # submit settings to a new week (new week should be created)
  end

  def rerank standings
    standings.update_all(rank: nil)   # not to have dups

    standings_ranks = self.tier_settings.map { |setting|
      (1..setting.total_teams).to_a.map { |rank| [setting.tier, rank] }
    }.flatten(1)

    standings.each_with_index { |standing, idx|
      standing.tier = standings_ranks[idx][0]
      standing.rank = standings_ranks[idx][1]
      standing.save
    }
  end

  def duplicate_settings cur_week_nr
    return if cur_week_nr == self.week

    self.league.weeks.where(week: cur_week_nr).destroy_all
    new_week = self.dup
    new_week.week = cur_week_nr
    new_week.save

    self.tier_settings.each {|setting| new_week.tier_settings.create(setting.dup.attributes) }

    # order setting standings & copy to current week
    standings = self.standings    # will be ordered
    rerank standings

    # and also save for current week
    standings.each { |standing| new_week.standings.create(standing.dup.attributes) }

  end

  def generate_schedule cur_week_nr
    cur_week = self.league.weeks.find_by_week(cur_week_nr)
    return unless cur_week

    cur_week.tier_settings.each { |setting|
      cycle = (setting.cycle || 1) - 1
      schedule = setting.schedule_pattern[cycle - 1] || setting.schedule_pattern.first
      schedule.each_with_index { |ts_schedule, game_idx|
        game_nr = game_idx + 1
        ts_schedule.each { |game|
          standing1 = cur_week.standings.find_by(rank: game[0], tier: setting.tier)
          standing2 = cur_week.standings.find_by(rank: game[1], tier: setting.tier)
          court = game[2]

          new_match = Match.new(standing1: standing1, standing2: standing2, court: court, game: game_nr)
          new_match.save
        }
      }
    }
  end


end
