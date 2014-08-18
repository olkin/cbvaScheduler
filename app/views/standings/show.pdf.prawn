require 'prawn/table'

if @standing and @standing.matches.any?

  team = @standing.team
=begin
  images = [[
                #{ :image => '#{Rails.root}/app/assets/images/cbva_logo.png', :image_height => 50 }
            ]]

  pdf.table images, :cell_style => { :border_width => 0 }
=end
  pdf.text "Hello team #{team.name} (#{team.captain})!"
  pdf.text "You're registered to #{team.league.description}"

  # TODO: tier name
  tier_settings = @standing.tier_setting

  if tier_settings
    pdf.text "You play in Tier ##{tier_settings.tier}"

    pdf.text "Your schedule for #{@standing.week.name}:"

    times         = tier_settings.match_times
    schedule      = @standing.matches.map do |match|
      opponent = match.opponent(@standing)

      [
          times[match.game - 1],
          match.court,
          "#{opponent.team.name}\n#{opponent.team.captain}"
      ]
    end

    schedule.unshift(['Time', 'Court', 'Fun teams to play against'])

    pdf.move_down 5

    #pdf.text schedule.inspect
    pdf.table schedule, :position => 10, :cell_style => { :border_width => 0.7, :align => :center, valign: :center }, :row_colors => ['FFFFFF', 'F0F0F0']
    pdf.move_down 10

    sets = tier_settings.set_points.size
    #TODO: add capped/not cap
    pdf.text "#{sets} #{'set'.pluralize(sets)} to #{tier_settings.set_points.join(', ')}, no cap (win by 2)"
    # TODO: add courts info
    pdf.text 'Courts C1-C12 are located @ CBVA : 28 Street SE & 30 Avenue SE'
    pdf.text 'Courts S1-S2 are located @ Schanks: 9627 Macleod Trail South'
    pdf.move_down 10


    pdf.text 'Good luck, have fun and stay hydrated!'
  else
    pdf.text 'Unfortunately, schedule is not ready yet'
  end

  pdf.text "#{League::NAME} organization team"

  # TODO: website as parameter
  pdf.text 'Scores and schedule updates can be found @ www.schankscbva.ca'

end
