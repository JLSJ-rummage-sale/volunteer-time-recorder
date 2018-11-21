class PlannedShift < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer
  has_one :time_record

  # Validations:

  validate :has_valid_time_range # Custom Validation.

  def has_valid_time_range
    if (end_time <= start_time)
      errors.add(:end_time, "must come after start time. Please enter a valid time range.")
    end
  end

  # Scopes:

  scope :sorted, lambda { order("start_time DESC") }
  scope :chronologically, lambda { order("start_time ASC") }

  # Other methods:

  def total_hours
    return TimeDifference.between(self.start_time, self.end_time).in_hours;
  end

  def associcated_time_record
    # Get the associated time_record:
    time_record_id = self.time_record_id;

    if (time_record_id)
      puts("TimeRecord ID found in planned_shift: " + time_record_id.to_s);

      time_record = TimeRecord.find(time_record_id);

      puts("TimeRecord OBJECT found in planned_shift: time_record: " + time_record.to_string);

      return time_record
    else
      return nil
    end

  end


end
