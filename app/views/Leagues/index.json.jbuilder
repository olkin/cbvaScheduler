json.array!(@leagues) do |league_type|
  json.extract! league_type, :id, :desc, :description
  json.url league_type_url(league_type, format: :json)
end
