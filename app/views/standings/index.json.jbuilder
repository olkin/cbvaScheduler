json.array!(@tier_settings) do |tier_setting|
  json.extract! tier_setting, :id, :week_id, :tier, :total_teams, :teams_down, :day, :schedule_pattern
  json.url tier_setting_url(tier_setting, format: :json)
end
