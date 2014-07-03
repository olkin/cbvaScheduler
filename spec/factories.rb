FactoryGirl.define do


  factory :user do
    name     "Jerry Brown"
    email    "jerry@brown.cc"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :league do
    sequence(:desc) {|n| "L#{n}"}
    sequence(:description) {|n| "League#{n}"}
  end

  factory :team do
    sequence(:name) {|n| "Team##{n}"}
    captain "Captain Jack"
    league
  end

  factory :tier_setting do
    week
    tier 1
    day "Sun"
    total_teams 2
    teams_down 0
    schedule_pattern [[[[1,2,1]],[[1,2,1]],[[1,2,1]]]]
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
    week 0
    court 1
    game 1
    team1 {association :team, name: "Team1"}
    team2 {association :team, league: team1.league, name: "Team2"}
  end
end
