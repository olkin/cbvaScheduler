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
    league
  end
end
