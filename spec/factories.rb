FactoryGirl.define do
  factory :user do
    name     "Jerry Brown"
    email    "jerry@brown.cc"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :league do
    desc "T8"
    description "Test8"
  end

  factory :team do
    name "VB Team"
    captain "Captain Jack"
    league
  end

  factory :tier_setting do
    tier "1"
    day "Sun"
    total_teams 2
    teams_down 0
    schedule_pattern "[[[[1,2,1]],[[1,2,1]],[[1,2,1]]]]"
    league
  end

  factory :standing do
    week 0
    rank 1
    tier 1
    team
  end

  factory :match do
    ignore do
      league {}
    end

    week 0
    court 1
    game 1
    team1 {association :team, league: league, name: "Team1"}
    team2 {association :team, league: league, name: "Team2"}
  end
end
