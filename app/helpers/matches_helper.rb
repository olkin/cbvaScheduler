module MatchesHelper

  def text_field_for_score(score, game_nr, team_idx)
    team_game_score = score[game_nr][team_idx] if score and score[game_nr]
    text_field_tag "score[#{game_nr}][#{team_idx}]", team_game_score, size: 2, readonly: !vip?
  end

  def team_data(match, stats, idx)
    standing = match.standing(idx)
    result = content_tag(:td, standing.rank)
    result << (content_tag :td, link_to("#{standing.team.short_name}", standing) + tag(:br) + standing.team.captain)
    match.sets_count.times do |game_idx|
      result << content_tag(:td, text_field_for_score(match.score, game_idx, idx))
    end
    result << content_tag(:td, stats[idx][:matches_won])
    result << content_tag(:td, stats[idx][:sets_won])
    result << content_tag(:td, stats[idx][:points_diff])
    result
  end
end
