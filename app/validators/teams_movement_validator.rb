class TeamsMovementValidator < ActiveModel::Validator
  def validate(record)

    return if record.errors[:teams_down].any? or record.errors[:total_teams].any? or record.errors[:tier].any?

    record.errors[:teams_down] << "Teams to move down cannot exceed number of teams in tier" \
      if record.total_teams < record.teams_down
  end
end