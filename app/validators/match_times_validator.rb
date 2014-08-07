class MatchTimesValidator < ActiveModel::Validator
  def validate(record)
    match_times = record.match_times
    record.errors[:match_times] << 'wrong format' unless match_times.is_a?Array
  end
end