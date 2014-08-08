FactoryGirl.define do


  factory :user do
    name 'Jerry Brown'
    email 'jerry@brown.cc'
    password 'foobar'
    password_confirmation 'foobar'
  end

  factory :league do
    sequence(:desc) {|n| "L#{n}"}
    sequence(:description) {|n| "League#{n}"}
  end

  factory :team do
    sequence(:name) {|n| "Team##{n}"}
    captain 'Captain Jack'
    league
  end

  factory :tier_setting do
    week
    tier 1
    day 'Sun'
    total_teams 2
    teams_down 0
    set_points [21, 21, 15]
    match_times %w(10:00 12:00 13:00)
    schedule_pattern [[[[1,2,1]],[[1,2,1]],[[1,2,1]]]]
    cycle 1
  end

  factory :week do
    league
  end

  factory :standing do
    week
    rank 1
    tier 1
    team {association :team, league: week.league}
  end

  factory :match do
    week
    court 1
    game 1
    standing1 {association :standing, rank: 1, week: week}
    standing2 {association :standing, rank: 2, week: standing1.week}
  end

end
