require 'prawn/table'

cur_week = @league.cur_week

cur_week.standings.each do |standing|
    images = [[
    {:image => "#{Rails.root}/app/assets/images/cbva_logo.png", :image_height => 50},
    {:image => "#{Rails.root}/app/assets/images/SCHANKS.jpg", :image_height => 50}
    ]]
    pdf.table images, :cell_style => { :border_width => 0}
    pdf.text "Hello team #{standing.team.name} (#{standing.team.captain})!"

    pdf.text "Welcome to 20th annual beach volleyball SCHANKS tournament (19-20 July, 2014)"

    if standing
       pdf.text "You play in #{standing.tier_setting.name} (#{@league.description})"
       pdf.text "Your schedule for July 19th, 2014:"
       times = eval(standing.tier_setting.match_times)
       prev_location = nil
       schedule = standing.matches.sort{|x,y| x.game<=>y.game}.map do |match|
        opponent = match.team1 == standing.team ? match.team2 : match.team1
        [
            times[match.game - 1],
            match.court_str,
            "#{opponent.name}\n#{opponent.captain}"
        ]
       end

       schedule.unshift(["Time", "Court", "Fun teams to play against"])

       pdf.move_down 5
       pdf.table schedule, :position => 10, :cell_style => { :border_width => 0.7, :align => :center, valign: :center }, :row_colors => ["FFFFFF","F0F0F0"]
        pdf.move_down 10
    end

    sets = eval(standing.tier_setting.set_points).size
    pdf.text "#{sets} #{'set'.pluralize(sets)} to #{eval(standing.tier_setting.set_points).join(', ')}, no cap (win by 2)"
    pdf.text "Courts C1-C12 are located @ CBVA : 28 Street SE & 30 Avenue SE"
    pdf.text "Courts S1-S2 are located @ Schanks: 9627 Macleod Trail South"
    pdf.move_down 10

    pdf.text "Good luck, have fun and stay hydrated!"
    pdf.text "CBVA organization team"

    pdf.text "Scores and schedule updates can be found @ www.schankscbva.ca or www.cbva.ca/main/tournaments.htm"

    pdf.start_new_page

end if cur_week and cur_week.week

=begin
cur_week.tier_settings.each do |setting|
    images = [[
        {:image => "#{Rails.root}/app/assets/images/cbva_logo.png", :image_height => 50},
        {:image => "#{Rails.root}/app/assets/images/SCHANKS.jpg", :image_height => 50}
        ]]
    pdf.table images, :cell_style => { :border_width => 0}

  pdf.text "Welcome to 20th annual beach volleyball SCHANKS tournament (19-20 July 2014)"

    pdf.text "#{@league.description}: Tier ##{setting.tier}, day #{cur_week.week + 1}"
    matches = cur_week.matches
    if matches
        max_game = matches.maximum("game")

        max_game.times do |idx|
            game_matches = matches.where(game: idx + 1)
            table_nr = 0

            game_matches.each do |match|
                if match.team1_standing.tier == setting.tier
                    games = []
                    games.push([
                      {content: (eval(setting.match_times)[idx] || "") + "\n@" + (match.court_str || ""), rowspan: 2},
                      match.team1.short_name + "\n" + match.team1.captain
                    ])


                    games.push([
                      match.team2.name + "\n" + match.team2.captain
                    ])

                    widths = [40,120]
                    eval(setting.set_points).size.times{
                      games[0].push("")
                      games[1].push("")
                      widths += [40]
                    }
                    total_width = widths.inject(:+)

                    pdf.move_up 85 if table_nr > 0

                    pdf.table games, :position => -10 + (total_width+5)*table_nr , :column_widths => widths, :cell_style => { :height => 40, :border_width => 0.7,  :align => :center, valign: :center, size: 10 }, :row_colors => ["FFFFFF","F0F0F0"]
                    table_nr += 1
                    table_nr %= 2
                    pdf.move_down 5
                end
            end if game_matches
        end

    end

    sets = eval(setting.set_points).size
    pdf.text "#{sets} #{'set'.pluralize(sets)} until #{eval(setting.set_points).join(', ')}, no cap (2 points diff)"
    pdf.text "Courts C1-C12 are located @ CBVA : 28 Street SE & 30 Avenue SE"
    pdf.text "Courts S1-S2 are located @ Schanks: 9627 Macleod Trail South"

    pdf.start_new_page

end if cur_week and cur_week.week
=end

if cur_week and cur_week.week
    standings_by_tier = cur_week.standings.group_by{|standing| standing[:tier]}

    standings_by_tier.each do |tier, standings|
        pdf.start_new_page(layout: :landscape)
        tier_setting = cur_week.tier_settings.find_by(tier: tier)
        images = [[
            {:image => "#{Rails.root}/app/assets/images/cbva_logo.png", :image_height => 50},
            {:image => "#{Rails.root}/app/assets/images/SCHANKS.jpg", :image_height => 50}
        ]]
        pdf.table images, :cell_style => { :border_width => 0}

        pdf.text "#{@league.description}: #{tier_setting.name || tier} , day #{cur_week.week + 1}", size:20

        schedule_sheet = [[""]]

        widths = [150]
        standings.each do |standing|
            widths.push(80)
            schedule_sheet[0].push(standing.team.name + "\n" + standing.team.captain)
        end

        2.times {
            schedule_sheet[0].push("")
            widths.push(50)
        }

        schedule_sheet += standings.each.map {|standing|
            row = [standing.team.name + "\n" + standing.team.captain]
            (standings.size + 2).times {row.push("")}
            row
        }

         pdf.move_down 5
         pdf.table(schedule_sheet, :column_widths => widths, :row_colors => ["FFFFFF","F0F0F0"], cell_style: {height:50})

         pdf.move_down 10

        set_points = eval(tier_setting.set_points)
        pdf.text "#{set_points.size} #{'set'.pluralize(set_points.size)} to #{set_points.join(', ')}, no cap (win by 2)"
        pdf.move_down 10
        pdf.text "Courts C1-C12 are located @ CBVA : 28 Street SE & 30 Avenue SE"
        pdf.text "Courts S1-S2 are located @ Schanks: 9627 Macleod Trail South"
        pdf.move_down 30
        pdf.text "Good luck! Have fun!"

    end
end
