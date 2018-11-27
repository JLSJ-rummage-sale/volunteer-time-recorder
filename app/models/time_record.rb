class TimeRecord < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer

  has_one :category

  # Validations:

  validate :has_valid_time_range # Custom Validation.

  def has_valid_time_range
    if (end_time <= start_time)
      errors.add(:end_time, "must come after start time. Please enter a valid time range.")
    end
  end

  # Scopes:

  scope :sorted, lambda { order("start_time DESC") }

  # Other methods:

  def total_hours
    return TimeDifference.between(self.start_time, self.end_time).in_hours;
  end

  def total_time_text
    return TimeDifference.between(self.start_time, self.end_time).humanize;
  end

  def category
    # Get the associated time_record:
    category_id = self.category_id;

    if (category_id)
      puts("Category ID found in time_record: " + category_id.to_s);

      category = Category.find_by_id(category_id);

      if (category)
        puts("Category OBJECT found in time_record: category: " + category.name);
        return category
      else
        puts("Category OBJECT NOT found in time_record: category_id: " + category_id.to_s);
        return nil
      end

    else
      return nil
    end

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
