require 'prawn/table'

def team_info standing
  "(#{standing.rank}) #{standing.team.name}\n #{standing.team.captain}"
end

def cross_results standings
  if standings.any?
    schedule_sheet = [[""]]

    widths = [150]
    standings.each do |standing|
      widths.push(80)
      schedule_sheet[0].push(team_info standing)
    end

    schedule_sheet[0].push('Match')
    schedule_sheet[0].push('Sets')
    schedule_sheet[0].push('Points')

    3.times { widths.push(50) }

    schedule_sheet += standings.each.map { |standing|
      row = [team_info(standing)]
      (standings.size + 3).times { row.push('') }
      row
    }

    pdf.move_down 5
    pdf.table(schedule_sheet, :column_widths => widths, :row_colors => ['FFFFFF', 'F0F0F0'], cell_style: { height: 50 })
  else
    pdf.text 'No teams registered'
  end
end


def add_tier_settings tier_setting
  pdf.move_down 10

  set_points = tier_setting.set_points
  #TODO: cap rule to configuration
  # fix set points
  #pdf.text "#{set_points.size} #{'set'.pluralize(set_points.size)} to #{set_points.join(', ')}, no cap (win by 2)"
  pdf.move_down 10
  # TODO: add courts location
  #pdf.text 'Courts C1-C12 are located @ CBVA : 28 Street SE & 30 Avenue SE'
  #pdf.text 'Courts S1-S2 are located @ Schanks: 9627 Macleod Trail South'
  pdf.move_down 30
  pdf.text 'Good luck! Have fun!'

  pdf.text 'Scores and schedule updates can be found @ www.schankscbva.ca'
end

def add_header tier_setting
  #TODO: replace Tier to tier name
  pdf.text "#{tier_setting.league.description}"
  pdf.text "Schedule for Tier ##{tier_setting.tier}"
end

=begin
def match_results matches
  max_game = matches.maximum('game')
  max_game.times do |idx|
    game_matches = matches.where(game: idx + 1)
    table_nr = 0

    game_matches.each do |match|
      if match.standing1.tier == setting.tier
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
=end


if @week and @week.tier_settings.any?
  pdf.text "Score sheets for  #{@week.league.description} (#{@week.name})"
  @week.tier_settings.each do |tier_setting|

=begin
    pdf.start_new_page
    add_header tier_setting
    #TODO - get only matches for this tier @ that week
    #match_results tier_setting.matches
    add_tier_settings tier_setting
=end

    standings = tier_setting.standings
    pdf.start_new_page(layout: :landscape)
    add_header tier_setting
    cross_results standings
    add_tier_settings tier_setting


  end
else
  pdf.text "No information available for week"
end