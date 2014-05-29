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
    start_date "2014-02-03"
  end
end
