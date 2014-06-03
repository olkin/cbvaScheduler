json.array!(@teams) do |team|
  json.extract! team, :id, :name, :captain, :email, :league_id
  json.url team_url(team, format: :json)
end
