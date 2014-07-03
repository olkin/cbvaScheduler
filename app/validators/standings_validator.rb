class StandingsValidator < ActiveModel::Validator
  def validate(record)
    standings = record.standings.all
    big_ranks = standings.select{|standing| standing.rank > standings.size}.map{|standing| standing.team.name}
    record.errors[:standings] << "Ranks for #{'team'.pluralize(big_ranks.size)} #{big_ranks.join(', ')} are too big" \
      if big_ranks.any?
  end
end