class PlannedShiftsController < ApplicationController
  # Before-Actions: (These will be executed before any public action below)
  before_action :find_parent_event, :only => [:index, :new];
  before_action :find_parent_volunteer, :only => [:index, :new];

  # CRUD Actions:

  def index

      if (params[:category_id])
        @category_filter = Category.find_by_id(params[:category_id]); # Will return an object or return nil.;
      end

      # Get all planned_shift records from the database to display:
      # Check if a parent event was passed in (from "find_event" method below):
      if (@parent_volunteer) # Check if variable exists and is not nil.
          puts("Filtering by volunteer passed in.");
          # Sort by date (oldest first) so can view like a list:
          @planned_shifts = @parent_volunteer.planned_shifts.chronologically;
      elsif (@parent_event) # Check if variable exists and is not nil.
          puts("Filtering by event passed in.");
          @planned_shifts = @parent_event.planned_shifts.sorted;
      else
          puts("NOT Filtering by anything.");
          @planned_shifts = PlannedShift.sorted.by_category(params[:category_id]);
      end


      respond_to do |format|
        format.html
        format.csv do
          all_shifts = PlannedShift.sorted
          send_data all_shifts.as_csv
        end
      end
  end

  def show
      # Get the planned_shift object that was selected:
      @planned_shift = PlannedShift.find(params[:id]);

      # @total_planned_time_text = TimeDifference.between(@planned_shift.start_time, @planned_shift.end_time).humanize;
      #
      # if (@planned_shift.sign_in_time && @planned_shift.sign_out_time)
      #   @total_actual_time_text = TimeDifference.between(@planned_shift.sign_in_time, @planned_shift.sign_out_time).humanize;
      # end
      #
      # @category_name = "[None]";
      # if @planned_shift.category
      #     @category_name = @planned_shift.category.name;
      # end

      # Get the associated event:
      event_id = @planned_shift.event_id;

      puts("Event ID found in planned_shift: " + event_id.to_s);

      @event = Event.find(event_id);

      puts("Event OBJECT found in planned_shift: " + @event.name);

      # Get the associated volunteer:
      volunteer_id = @planned_shift.volunteer_id;

      puts("Volunteer ID found in planned_shift: " + volunteer_id.to_s);

      @volunteer = Volunteer.find(volunteer_id);

      puts("Volunteer OBJECT found in planned_shift: " + @volunteer.email_address);

      # Get the associated time_record:
      # time_record_id = @planned_shift.time_record_id;
      #
      # if (time_record_id)
      #   puts("TimeRecord ID found in planned_shift: " + time_record_id.to_s);
      #
      #   @time_record = TimeRecord.find(time_record_id);
      #
      #   puts("TimeRecord OBJECT found in planned_shift: time_record.id: " + @time_record.id.to_s);
      # end

      @time_record = @planned_shift.associcated_time_record
      puts ("Assoiciated Time Record Found = #{@planned_shift.associcated_time_record}")

      @spreadsheet = get_spreadsheet_creator_if_exists(@planned_shift)

  end

  # Called when rendering the New PlannedShift page:
  def new
      # Check if can create a Planned Shift yet:
      # Check if there are any Events or Volunteers yet:
      if Event.count < 1 || Volunteer.count < 1
        render 'warn_cannot_add'
      end

      # Create a new planned_shift instance that will be used in the form:
      @planned_shift = PlannedShift.new;

      # Get all volunteer and event records for the form selection:
      @volunteers = Volunteer.sorted;
      @events = Event.all;

      # Get preselected Event or Volunteer:
      if (@parent_volunteer) # Check if variable exists and is not nil.
          @selected_volunteer = @parent_volunteer;
          puts("Set SELECTED_VOLUNTEER to " + @selected_volunteer.email_address);
      else
          @selected_volunteer = Volunteer.first;
      end

      if (@parent_event) # Check if variable exists and is not nil.
          @selected_event = @parent_event;
          puts("Set SELECTED_EVENT to " + @selected_event.name);
      else
          @selected_event = Event.first;
      end

      # Get all volunteer records for the form selection:
      @categories = Category.all;

      # Get preselected Category:
      @selected_category = Category.first;
  end

  # Called when the New PlannedShift form is submitted:
  def create
      # Create a new planned_shift instance that will be used in the form:
      @planned_shift = PlannedShift.new(planned_shift_params);

      if(@planned_shift.save)
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Planned Shift created successfully.";

          # If saved to DB successfully, go to show page:
          redirect_to @planned_shift;
        else
            # If validations prevented save, reload form (with error message):

            redirect_to new_planned_shift_path(@planned_shift,
              :event_id => @planned_shift.event_id,
              :volunteer_id => @planned_shift.volunteer_id);

            # Need to get errors indirectly because redirecting won't automatically show erors:
            flash[:alert] = @planned_shift.errors.full_messages.join("\n");
        end
  end

  # Called when rendering the Edit PlannedShift page:
  def edit
      # Get the planned_shift object that was selected:
      @planned_shift = PlannedShift.find(params[:id]);

      # Get all volunteer and event records for the form selection:
      @volunteers = Volunteer.all;
      @events = Event.all;

      # Set the default selected event & volunteer in the form:
      @selected_event = Event.find(@planned_shift.event_id);
      @selected_volunteer = Volunteer.find(@planned_shift.volunteer_id);

      # Get all category records for the form selection:
      @categories = Category.all;
      # Get preselected Category:
      @selected_category = Category.first;
      if (@planned_shift.category) # Check if variable exists and is not nil.
          @selected_category = @planned_shift.category;
      end
  end

  # Called when the Edit PlannedShift form is submitted:
  def update
      # Get the planned_shift object that was selected:
      @planned_shift = PlannedShift.find(params[:id]);

      if(@planned_shift.update(planned_shift_params))
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Planned Shift updated successfully.";

          # If saved to DB successfully, go to show page:
          redirect_to @planned_shift;
      else
          # If validations prplanned_shifted save, reload form (with error message):
          render 'edit';
      end
  end


  def delete
      @planned_shift = PlannedShift.find(params[:id]);
  end

  def destroy
      @planned_shift = PlannedShift.find(params[:id]);

      @planned_shift.remove_spreadsheet_connection

      @planned_shift.destroy;

      # Present a 1-time flash message to the user after redirect:
      flash[:notice] = "Planned Shift '#{@planned_shift.name}' deleted successfully.";

      redirect_to(planned_shifts_path);
  end


  # Other actions:

  def check_in
    # TODO:
    # Check if already checked-in:
    #  TODO....rediect to different page.

    # Get the planned_shift object that was selected:
    @planned_shift = PlannedShift.find(params[:id]);

    # @planned_shift.sign_in_time = Time.now;
  end

  def checked_in
    # Get the planned_shift object that was selected:
    @planned_shift = PlannedShift.find(params[:id]);

    if(@planned_shift.update(check_in_params))
        # Present a 1-time flash message to the user after redirect:
        flash[:notice] = "Checked In successfully.";

        # If saved to DB successfully, go to show page:
        redirect_to @planned_shift;
    else
        # If validations prplanned_shifted save, reload form (with error message):
        render 'check_in';
    end
  end

  def check_out
    # TODO:
    # Check if already checked-out:
    #  TODO....rediect to different page.

    # Get the planned_shift object that was selected:
    @planned_shift = PlannedShift.find(params[:id]);
  end

  def checked_out
    # Get the planned_shift object that was selected:
    @planned_shift = PlannedShift.find(params[:id]);

    if(@planned_shift.update(check_out_params))
        # Create a Time Record with the same details as the check-in/out times:
        time_record = create_associated_time_record(@planned_shift)

        # Update with newly associated Time Record:
        @planned_shift.time_record_id = time_record.id

        if (@planned_shift.save)
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Checked Out successfully.";

          # If saved to DB successfully, go to show page:
          redirect_to @planned_shift;
        else
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Failed to Check Out (failed to create a Time Record). Contact the site admin.";

          # If validations prevented save, reload form (with error message):
          render 'check_out';
        end

    else
        # If validations prevented save, reload form (with error message):
        render 'check_out';
    end
  end

  private

  # Defines the acceptable fields for planned_shift:
  def planned_shift_params
      params.require(:planned_shift).permit(:start_time,
          :end_time, :name, :notes, :event_id, :volunteer_id, :category_id);
  end

  def check_in_params
      params.require(:planned_shift).permit(:sign_in_time);
  end

  def check_out_params
      params.require(:planned_shift).permit(:sign_out_time);
  end

  def create_associated_time_record(planned_shift)
    time_record = TimeRecord.create(start_time: planned_shift.sign_in_time,
        end_time: planned_shift.sign_out_time,
        category_id: planned_shift.category_id,
        event_id: planned_shift.event_id,
        volunteer_id:planned_shift.volunteer_id);

    return time_record
  end

  # A Before-Action method to get the event passed from a different controller:
  # Sets a variable 'parent_event' if an event object was passed in:
  def find_parent_event
      # Find event passed in from filter:
      @parent_event = Event.find_by_id(params[:event_id]); # Will return an object or return nil.

      # DEBUG ONLY:
      puts("find_event: Event OBJECT passed in: " + @parent_event.to_s);

      if (@parent_event)
          puts("found event: " + @parent_event.name);
      else
          puts("didn't find event.")
      end
  end

  # A Before-Action method to get the event passed from a different controller:
  # Sets a variable 'parent_event' if an event object was passed in:
  def find_parent_volunteer
      # Find event passed in from filter:
      @parent_volunteer = Volunteer.find_by_id(params[:volunteer_id]); # Will return an object or return nil.

      # DEBUG ONLY:
      puts("find_volunteer: volunteer OBJECT passed in: " + @parent_volunteer.to_s);

      if (@parent_volunteer)
          puts("found volunteer: " + @parent_volunteer.email_address);
      else
          puts("didn't find volunteer.")
      end
  end


  def get_spreadsheet_creator_if_exists(planned_shift)
    planned_shift_import_record = PlannedShiftsUploaded.find_by_planned_shift_id(planned_shift.id)

    puts "lookup planned_shift_import_record = #{planned_shift_import_record}"

    if (planned_shift_import_record)
      puts "found planned_shift_import_record.spreadsheet = #{planned_shift_import_record.spreadsheet}"
      return planned_shift_import_record.spreadsheet
    else
      return nil
    end
  end


  def set_page_section
    @page_section = "planned_shift"
  end


end
