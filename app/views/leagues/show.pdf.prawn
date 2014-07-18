require 'prawn/table'

cur_week = @league.cur_week

@league.teams.each do |team|
    images = [[
    {:image => "#{Rails.root}/app/assets/images/cbva_logo.png", :image_height => 50},
    {:image => "#{Rails.root}/app/assets/images/SCHANKS.jpg", :image_height => 50}
    ]]
    pdf.table images, :cell_style => { :border_width => 0}
    pdf.text "Hello team #{team.name}"

    pdf.text "Welcome to 20th annual beach volleyball SCHANKS tournament (19-20 July 2014)"
    pdf.text "You are registered for competition #{@league.description}"

    standing = cur_week.standings.find_by(team: team)
    if standing
       pdf.text "You start as team ##{standing.rank} in tier ##{standing.tier}"
       pdf.text "Your schedule for July 19th, 2014:"
       times = eval(standing.tier_setting.match_times)
       prev_location = nil
       schedule = standing.matches.map do |match|
        opponent = match.team1 == team ? match.team2 : match.team1
        [
            times[match.game - 1],
            match.court_str,
            "#{opponent.name} (#{opponent.captain})"
        ]
       end

       schedule.unshift(["Time", "Court", "Fun teams to play against"])

       pdf.move_down 5
       pdf.table schedule, :position => 10, :cell_style => { :border_width => 0.7, :align => :center }, :row_colors => ["FFFFFF","F0F0F0"]
        pdf.move_down 10
    end

    pdf.text "You play #{eval(standing.tier_setting.set_points).size} sets until #{eval(standing.tier_setting.set_points).join(', ')}, capped"
    pdf.text "Courts C1-C12 are located @ CBVA : 28 Street SE & 30 Avenue SE"
    pdf.text "Courts S1-S2 are located @ Schanks: 9627 Macleod Trail South"
    pdf.move_down 10

    pdf.text "Good luck!!!"
    pdf.text "CBVA team"

    pdf.text "Scores and schedule updates can be found @ www.schankscbva.ca"

    pdf.start_new_page

end if cur_week