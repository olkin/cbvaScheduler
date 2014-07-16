class MatchTimesValidator < ActiveModel::Validator
  def validate(record)
    match_times = record.match_times
    record.errors[:match_times] << "wrong format" if !match_times or match_times.blank? or !eval(match_times)
  end
end