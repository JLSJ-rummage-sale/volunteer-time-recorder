module VolunteersHelper

    def full_name(volunteer)
        return (volunteer.first_name.to_s + " " + volunteer.last_name.to_s);
    end

    def full_name_with_email(volunteer)
        return (volunteer.first_name.to_s + " " + volunteer.last_name.to_s + " <" + volunteer.email_address + ">");
    end

    def total_time_for_all_time_records(time_records)
        sum = 0;

        time_records.each do |time_record|
            sum += time_record.total_hours;
        end

        return sum;
    end

    def total_hours_volunteered(volunteer)
      total_time_for_all_time_records(volunteer.time_records);
    end

    def quota_completion_percent(volunteer, quota)
      hours_worked = quota_hours_completed(volunteer, quota);

      if (quota.hours <= 0)
        percent = 100.0;
      else
        percent = (hours_worked / quota.hours) * 100;
      end

      return percent.round(1);
    end

    def quota_hours_completed(volunteer, quota)
      total_hours = 0;

      volunteer.time_records.each do |time_record|
          if (time_record.category_id == quota.category_id)
            total_hours += time_record.total_hours;
          end
      end

      return total_hours;
    end

end
