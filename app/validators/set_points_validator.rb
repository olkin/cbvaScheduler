class SetPointsValidator < ActiveModel::Validator
  def validate(record)
    set_points = record.set_points
    unless set_points.is_a?Array
      record.errors[:set_points] << 'wrong format'
      return
    end


    set_points.each_with_index do |points, set|
      record.errors[:set_points] << "Points for set ##{set + 1} should more than 0" if points <= 0
    end

  end
end