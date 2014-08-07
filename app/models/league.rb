require 'json'

class League < ActiveRecord::Base
  NAME = 'Volleyball League'  #TODO: configure

  has_many :teams, dependent: :destroy
  has_many :weeks, dependent: :destroy

  validates :desc, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true

  DEFAULT_SCHEDULE_PATTERNS = {
      2 => [[[[1,2,1]],[[1,2,1]],[[1,2,1]]]],
      4 => [[[[1,4,1],[2,3,2]],[[1,3,1],[2,4,2]],[[1,2,1],[3,4,2]]]]
  }

=begin
  def cur_week
    weeks.order('week DESC').first
  end
=end

end
