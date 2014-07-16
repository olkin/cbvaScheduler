class SetPointsValidator < ActiveModel::Validator
  def validate(record)
    set_points = record.set_points
    record.errors[:set_points] << "wrong format" if !set_points or set_points.blank? or !eval(set_points)
  end
end