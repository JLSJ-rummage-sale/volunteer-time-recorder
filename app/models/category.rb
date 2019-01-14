class Category < ApplicationRecord
  # Required fields:
  validates :name, presence: true

  # Other methods:

  def total_hours_completed
    time_records = TimeRecord.by_category(self.id)

    hours_completed_sum = 0

    time_records.each do |time_record|
      hours_completed_sum += time_record.total_hours
    end

    return hours_completed_sum
  end

  def total_hours_planned
    planned_shifts = PlannedShift.by_category(self.id)

    hours_planned_sum = 0

    planned_shifts.each do |planned_shift|
      hours_planned_sum += planned_shift.total_hours
    end

    return hours_planned_sum
  end

end
