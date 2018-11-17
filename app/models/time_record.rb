class TimeRecord < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer

  # Scopes:

  scope :sorted, lambda { order("start_time DESC") }

  # Other methods:

  def total_hours
    return TimeDifference.between(self.start_time, self.end_time).in_hours;
  end

  def total_time_text
    return TimeDifference.between(self.start_time, self.end_time).humanize;
  end

  def to_string
      return "TIME_RECORD:{id: " + self.id.to_s + ", " +
              "start_time: " + self.start_time.to_s + ", " +
              "end_time: " + self.end_time.to_s + ", " +
              "name: " + self.name.to_s + ", " +
              "event_id: " + self.event_id.to_s + ", " +
              "volunteer_id: " + self.volunteer_id.to_s +
              " }";
  end

end
