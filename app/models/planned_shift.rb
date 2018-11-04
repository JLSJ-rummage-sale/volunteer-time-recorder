class PlannedShift < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer
  has_one :time_record

  # Scopes:

  scope :sorted, lambda { order("start_time DESC") }

  # Other methods:

  def total_hours
    return TimeDifference.between(self.start_time, self.end_time).in_hours;
  end
end
