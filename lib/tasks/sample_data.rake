namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    leagues = League.all
    for idx in 1..10
      name = "Team" + idx.to_s
      leagues.each { |league| league.teams.create!(name: name, captain: "Captain Jack") }

    end
  end

end