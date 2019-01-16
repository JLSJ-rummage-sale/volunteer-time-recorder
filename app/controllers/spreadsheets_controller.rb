class SpreadsheetsController < ApplicationController

  def index
      # Get all spreadsheet records from the database to display:
      @spreadsheets = Spreadsheet.all;
  end

  def show
      # Get the spreadsheet object that was selected:
      @spreadsheet = Spreadsheet.find(params[:id]);

      @event = Event.find(@spreadsheet.event_id);

      @volunteers_uploaded = @spreadsheet.volunteers #VolunteersUploaded.for_spreadsheet(@spreadsheet.id)
      #puts "@volunteers_uploaded.size = #{@volunteers_uploaded.size}"
      @planned_shifts_uploaded = @spreadsheet.planned_shifts #PlannedShiftsUploaded.for_spreadsheet(@spreadsheet.id)

      @import_errors = @spreadsheet.import_errors
  end

  # Called when rendering the New Event page:
  def new
      # Create a new event instance that will be used in the form:
      @spreadsheet = Spreadsheet.new;
  end

  # Called when the New Event form is submitted:
  def create
      #Create a new spreadsheet instance that will be used in the form:
      @spreadsheet = Spreadsheet.new();
      @spreadsheet.event_id = spreadsheet_params[:event_id]

      file_to_import = spreadsheet_params[:uploaded_file]
      puts "file_to_import = #{file_to_import.to_s}"

      @file_name = "[No file selected]"

      if (file_to_import)
        @file_name = file_to_import.original_filename
        @spreadsheet.file_name = @file_name

        event = Event.find(@spreadsheet.event_id)

        parse_file(file_to_import, event)

        @spreadsheet.num_rows = @num_rows

        if (@import_errors.count > 0)
          @spreadsheet.status = "errors"
        else
          @spreadsheet.status = "success"
        end

        if(@spreadsheet.save)
            save_uploaded_volunteers(@spreadsheet.id, @volunteers_created)
            save_uploaded_planned_shifts(@spreadsheet.id, @planned_shifts_created)
            save_import_errors(@spreadsheet.id, @import_errors)

            flash[:notice] = "File uploaded successfully. File Name: #{@file_name}";

            if (@import_errors.count > 0)
              flash[:alert] = "Errors found in file uploaded. Check error messages below.";
            end

            # If saved to DB successfully, go to show page:
            redirect_to @spreadsheet;
        else
            # If validations prevented save, reload form (with error message):
            render 'new';
        end
      else
        flash[:alert] = "File failed to uploaded. File: #{@file_name}";

        render 'new';
      end

  end

  # def import_file(file_uploaded)
  #
  #   puts "NOW IN SPREADSHEETS/IMPORT..."
  #
  #   @file_name = "[No file selected]"
  #
  #   if (file_uploaded)
  #     puts "file_uploaded.class.name = #{file_uploaded.class.name}"
  #
  #     puts "file_uploaded.path = #{file_uploaded.path}"
  #
  #     parse_file(file_uploaded)
  #
  #     @file_name = file_uploaded.original_filename
  #
  #     flash[:notice] = "File uploaded successfully. File Name: #{@file_name}";
  #   else
  #     flash[:alert] = "File failed to uploaded. File: #{@file_name}";
  #     puts "ISSUE: No params[:file]"
  #   end
  #
  #   redirect_to spreadsheets_path
  # end



  private

  # Defines the acceptable fields for Volunteer:
  def spreadsheet_params
      params.require(:spreadsheet).permit(:event_id, :uploaded_file);
  end

  def save_uploaded_volunteers(spreadsheet_id, volunteers_created)

    volunteers_created.each do |new_volunteer|
      puts "attempting to add new_volunteer.id = #{new_volunteer.id} to VolunteersUploaded..."
      volunteer_uploaded_record = VolunteersUploaded.new()
      volunteer_uploaded_record.spreadsheet_id = spreadsheet_id
      volunteer_uploaded_record.volunteer_id = new_volunteer.id

      if (volunteer_uploaded_record.save)
        puts "successfully saved volunteer_uploaded_record = #{volunteer_uploaded_record}"
      else
        puts "failed to save volunteer_uploaded_record = #{volunteer_uploaded_record}"
        if (volunteer_uploaded_record.errors.any?)
            volunteer_uploaded_record.errors.full_messages.each do |error_message|
                puts error_message.to_s
            end
        end
      end
    end

  end

  def save_uploaded_planned_shifts(spreadsheet_id, planned_shifts_created)

    planned_shifts_created.each do |new_planned_shift|
      planned_shift_uploaded_record = PlannedShiftsUploaded.new()
      planned_shift_uploaded_record.spreadsheet_id = spreadsheet_id
      planned_shift_uploaded_record.planned_shift_id = new_planned_shift.id

      puts "...for new_planned_shift.id = #{new_planned_shift.id}"
      if (planned_shift_uploaded_record.save)
        puts "successfully saved planned_shift_uploaded_record = #{planned_shift_uploaded_record}"
      else
        puts "failed to save planned_shift_uploaded_record = #{planned_shift_uploaded_record}"
        if (planned_shift_uploaded_record.errors.any?)
            planned_shift_uploaded_record.errors.full_messages.each do |error_message|
                puts error_message.to_s
            end
        end
      end
    end

  end

  def save_import_errors(spreadsheet_id, import_errors)
    import_errors.each do |import_error|
      import_error.spreadsheet_id = spreadsheet_id

      if (import_error.save)
        puts "successfully saved import_error = #{import_error}"
      else
        puts "failed to save import_error = #{import_error}"
        if (import_error.errors.any?)
            import_error.errors.full_messages.each do |error_message|
                puts error_message.to_s
            end
        end
      end
    end

  end


  def concat_errors(errors)
    all_errors_text =  ""

    if (errors.any?)
        errors.full_messages.each do |error_message|
            all_errors_text += error_message.to_s + " \n"
        end
    end

    return all_errors_text
  end


  def parse_file(file, event)

    puts "Parsing file..."

    @num_rows = 0
    @import_errors = []
    @volunteers_created = []
    @planned_shifts_created = []

    CSV.foreach(file.path, headers: true) do |row|

      @num_rows += 1 # Increment row count.

      row_fields = row.to_hash

      puts "row_fields = #{row_fields}"

      # There must be an email field:
      if (!row_fields["Email"])
        @import_errors << new_import_error(row_fields, "There must be a column named 'Email' in the spreadsheet uploaded.")

        puts "ERROR: There must be an email field"

        return nil
      end

      volunteer = create_volunteer_from_csv(row_fields)

      puts "VOLUNTEER = #{volunteer}"

      if (volunteer)
        puts "ADDING PLANNED SHIFT FOR VOLUNTEER..."

        # There must be fields for date, start_time, and end_time:
        if (!row_fields["Date"] || !row_fields["Start Time"] || !row_fields["End Time"])
          @import_errors << new_import_error(row_fields, "There must be columns named 'Date', 'Start Time', and 'End Time' in the spreadsheet uploaded.")

          puts "ERROR: There must be fields for date, start_time, and end_time"

          return
        end

        planned_shift = create_planned_shift_from_csv(row_fields, volunteer, event)

        if (planned_shift && planned_shift.save)
          puts "SAVING PLANNED SHIFT FOR VOLUNTEER..."
          volunteer.planned_shifts << planned_shift

          if (volunteer.save)
            puts "able to add planned shift for #{volunteer.email_address}"
          else
            puts "ERROR: NOT able to add planned shift for #{volunteer.email_address}"
          end
        end
      end


      puts "volunteers_created = #{@volunteers_created}"

      puts "planned_shifts_created = #{@planned_shifts_created}"

      puts "import_errors = #{@import_errors}"
    end # end CSV.foreach
  end


  def set_page_section
    @page_section = "spreadsheet"
  end

  def new_import_error(row_fields, error_message)
    import_error = ImportError.new()

    import_error.row_data = row_fields
    import_error.row_number = @num_rows
    import_error.error_message = error_message

    return import_error
  end


  def create_volunteer_from_csv(row_fields)
    last_name = row_fields["Last Name"]
    first_name = row_fields["First Name"]
    email = row_fields["Email"]

    existing_volunteer = Volunteer.find_by_email_address(email)

    puts "existing_volunteer = #{existing_volunteer.to_s}"

    if (existing_volunteer)
      puts "Volunteer already exists: #{first_name} #{last_name}, #{email}"

      return existing_volunteer
    else
      puts "Will CREATE Volunteer: #{first_name} #{last_name}, #{email}"

      new_volunteer = Volunteer.new(first_name: first_name, last_name: last_name, email_address: email)

      if (new_volunteer.save)
        @volunteers_created << new_volunteer

        return new_volunteer
      else
        @import_errors << new_import_error(row_fields, "Failed to save volunteer: \n" + concat_errors(new_volunteer.errors))

        puts "ERROR: failed to save new_volunteer"

        return nil
      end
    end
  end # create_volunteer_from_csv end


  def create_planned_shift_from_csv(row_fields, volunteer, event)
    date = row_fields["Date"]
    puts "row_fields['Date'] = #{row_fields['Date']}"
    start_time = row_fields["Start Time"]
    end_time = row_fields["End Time"]

    # Date format: "03/12/2018": Date.strptime("03/12/2018", '%m/%d/%Y')
    shift_date = Date.strptime(date.to_s, '%m/%d/%Y')
    puts "shift_date = #{shift_date}"

    shift_start_time = parse_hour(start_time)
    shift_end_time = parse_hour(end_time)

    shift_start_date_time = get_date_time(shift_date, shift_start_time)
    shift_end_date_time = get_date_time(shift_date, shift_end_time)

    # Convert to Time object:
    shift_start_date_time = Time.zone.parse(shift_start_date_time.to_s)
    shift_end_date_time = Time.zone.parse(shift_end_date_time.to_s)


    new_planned_shift = PlannedShift.new #(start_time: shift_start_date_time, end_time: shift_end_date_time)
    new_planned_shift.start_time = shift_start_date_time
    new_planned_shift.end_time = shift_end_date_time

    # puts "/before-save/- - - - > new_planned_shift.start_time = #{new_planned_shift.start_time}; class = #{new_planned_shift.start_time.class.name}"

    # Must set associated volunteer and event to save successfully:
    new_planned_shift.volunteer = volunteer
    new_planned_shift.event = event

    if (new_planned_shift.save)
      @planned_shifts_created << new_planned_shift

      # puts "/after-save/- - - - > new_planned_shift.start_time = #{new_planned_shift.start_time}"

      return new_planned_shift
    else
      @import_errors << new_import_error(row_fields, "Failed to save shift: \n" + concat_errors(new_planned_shift.errors))

      puts "ERROR: failed to save new_planned_shift"

      return nil
    end
  end # create_planned_shift_from_csv end


  def get_date_time(date, time)
    #puts "----> in get_date_time: date = #{date}; class = #{date.class.name}"
    t_local = Time.zone.local(date.year, date.month, date.day, time.hour, time.min)

    # puts "--------> in get_date_time: t_local = #{t_local}; class = #{t_local.class.name}"
    # puts "--------> in get_date_time: t_local.zone = #{t_local.zone}"

    return t_local
  end


  def parse_hour(time)
    # Time formats: "5pm" or "5:00 PM":
    hour = Time.parse(time) # Returns the current date with the specified hour.

    return hour
  end

end
