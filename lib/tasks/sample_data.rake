namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    leagues = League.all
    (1..10).each { |idx|
      name = 'Team' + idx.to_s
      leagues.each { |league| league.teams.create!(name: name, captain: 'Captain Jack') }

    }
  end

end