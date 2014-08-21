module MatchesHelper

  def standing_field(standing)
    link_to("#{standing.team.short_name}", standing) + tag(:br) + standing.team.captain
  end

  def text_field_for_score(score, game_nr, team_idx)
    team_game_score = score[game_nr][team_idx] if score and score[game_nr]
    text_field_tag "score[#{game_nr}][#{team_idx}]", team_game_score, size: 2, readonly: !vip?
  end
end
