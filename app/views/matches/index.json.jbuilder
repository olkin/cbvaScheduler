json.array!(@matches) do |match|
  json.extract! match, :id, :team1_id, :team2_id, :score1, :score2, :court
  json.url match_url(match, format: :json)
end
