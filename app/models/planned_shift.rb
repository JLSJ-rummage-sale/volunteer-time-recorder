class PlannedShift < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer

  has_one :time_record
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


  def category
    category_id = self.category_id;

    if (category_id)
      puts("Category ID found in planned_shift: " + category_id.to_s);

      category = Category.find_by_id(category_id);

      if (category)
        puts("Category OBJECT found in planned_shift: category: " + category.name);
        return category
      else
        puts("Category OBJECT NOT found in planned_shift: category_id: " + category_id.to_s);
        return nil
      end

    else
      return nil
    end
  end


  def category_name
    if self.category
        return self.category.name;
    else
      return "[None]";
    end
  end


  def total_planned_time_text
    return TimeDifference.between(self.start_time, self.end_time).humanize;
  end


  def total_actual_time_text
    if (self.sign_in_time && self.sign_out_time)
      return TimeDifference.between(self.sign_in_time, self.sign_out_time).humanize;
    else
      return nil;
    end
  end

  def actual_time_range_text
    return "#{self.sign_in_time.strftime("%I:%M %p")} - #{self.sign_out_time.strftime("%I:%M %p")}";
  end

end
