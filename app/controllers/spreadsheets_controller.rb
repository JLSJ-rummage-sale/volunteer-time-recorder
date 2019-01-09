class SpreadsheetsController < ApplicationController

  require 'csv'

  def index
      # Get all event records from the database to display:
      # @events = Event.all;
  end

  def show
      # Get the event object that was selected:
      # @event = Event.find(params[:id]);
  end

  # Called when rendering the New Event page:
  def new
      # Create a new event instance that will be used in the form:
      # @event = Event.new;
  end

  # Called when the New Event form is submitted:
  def create
      # Create a new event instance that will be used in the form:
      # @event = Event.new(event_params);
      #
      # if(@event.save)
      #     # Present a 1-time flash message to the user after redirect:
      #     flash[:notice] = "Event created successfully.";
      #
      #     # If saved to DB successfully, go to show page:
      #     redirect_to @event;
      # else
      #     # If validations prevented save, reload form (with error message):
      #     render 'new';
      # end
  end

  def import

    puts "NOW IN SPREADSHEETS/IMPORT..."

    @file_name = "[No file selected]"

    puts "params[:uploaded_file] = #{params[:uploaded_file].to_s}"

    if (params[:uploaded_file])
      file_uploaded = params[:uploaded_file]

      puts "file_uploaded.class.name = #{file_uploaded.class.name}"

      puts "file_uploaded.path = #{file_uploaded.path}"

      parse_file(file_uploaded)

      @file_name = file_uploaded.original_filename

      flash[:notice] = "File uploaded successfully. File Name: #{@file_name}";
    else
      flash[:alert] = "File failed to uploaded. File: #{@file_name}";
      puts "ISSUE: No params[:file]"
    end

    redirect_to spreadsheets_path
  end



  private

  def parse_file(file)

    puts "Parsing file..."

    @error_rows = []
    @volunteers_created = []
    @planned_shifts_created = []

    CSV.foreach(file.path, headers: true) do |row|

      row_fields = row.to_hash

      puts "row_fields = #{row_fields}"

      event = Event.first # TODO: Change: Let user pick event...

      volunteer = create_volunteer_from_csv(row_fields)

      puts "VOLUNTEER ADDED = #{volunteer}"

      if (volunteer)
        puts "ADDING PLANNED SHIFT FOR VOLUNTEER..."
        planned_shift = create_planned_shift_from_csv(row_fields, volunteer, event)

        if (planned_shift)
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

      puts "error_rows = #{@error_rows}"

      # product_hash = row.to_hash # exclude the price field
      # product = Product.where(id: product_hash["id"])
      #
      # if product.count == 1
      #   product.first.update_attributes(product_hash)
      # else
      #   Product.create!(product_hash)
      # end # end if !product.nil?


    end # end CSV.foreach
  end


  def set_page_section
    @page_section = "spreadsheet"
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
        @error_rows << row_fields

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
      @error_rows << row_fields

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
