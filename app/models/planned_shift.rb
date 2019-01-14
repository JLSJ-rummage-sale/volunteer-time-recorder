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
  scope :by_category, lambda { |category_id| where("category_id = ?", category_id) if category_id.present? }

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

  def date_text(date_time)
    # Format: "03/13/2019":
    return date_time.strftime("%m/%d/%Y")#("%a, %b %d")
  end

  def shift_date_text
    return date_text(self.start_time)
  end

  def check_in_date_text
    if (self.sign_in_time)
      return date_text(self.start_time)
    else
      return "Not Checked-In Yet"
    end
  end

  def time_text(time)
    if (time)
      return time.strftime("%I:%M %p")
    else
      return ""
    end
  end




  # Export to CSV:
  def self.as_csv
    CSV.generate do |csv|
      # Create row names that are more readable:
      custom_column_names = ["Planned Shift Id",
                             "Volunteer Id",
                             "Volunteer First Name",
                             "Volunteer Last Name",
                             "Event",
                             "Shift Date",
                             "Shift Start Time",
                             "Shift End Time",
                             "Check-In Date",
                             "Check-In Time",
                             "Check-Out Time",
                             "Category",
                             "Created At",
                             "Updated At"]

      csv << custom_column_names

      all.each do |shift|
        row_hash = {"Planned Shift Id" => shift.id.to_s,
          "Volunteer Id" => shift.volunteer.id,
          "Volunteer First Name" => shift.volunteer.first_name,
          "Volunteer Last Name" => shift.volunteer.last_name,
          "Event" => shift.event.event_title,
          "Shift Date" => shift.shift_date_text,
          "Shift Start Time" => shift.time_text(shift.start_time),
          "Shift End Time" => shift.time_text(shift.end_time),
          "Check-In Date" => shift.check_in_date_text,
          "Check-In Time" => shift.time_text(shift.sign_in_time),
          "Check-Out Time" => shift.time_text(shift.sign_out_time),
          "Category" => shift.category_name,
          "Created At" => shift.created_at,
          "Updated At" => shift.updated_at}

        row_array = row_hash.values
        csv << row_array
      end
    end # CSV.generate end.
  end

end
