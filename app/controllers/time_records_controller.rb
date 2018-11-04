class TimeRecordsController < ApplicationController

    # Before-Actions: (These will be executed before any public action below)
    before_action :find_parent_event, :only => [:index, :new];
    before_action :find_parent_volunteer, :only => [:index, :new];

    # CRUD Actions:

    def index
        # Get all time_record records from the database to display:
        # Check if a parent event was passed in (from "find_event" method below):
        if (@parent_volunteer) # Check if variable exists and is not nil.
            puts("Filtering by volunteer passed in.");
            @time_records = @parent_volunteer.time_records.sorted;
        elsif (@parent_event) # Check if variable exists and is not nil.
            puts("Filtering by event passed in.");
            @time_records = @parent_event.time_records.sorted;
        else
            puts("NOT Filtering by event passed in.");
            @time_records = TimeRecord.sorted;
        end
    end

    def show
        # Get the time_record object that was selected:
        @time_record = TimeRecord.find(params[:id]);

        @total_time_text = TimeDifference.between(@time_record.start_time, @time_record.end_time).humanize;

        @category_name = @time_record.category;
        if @category_name.empty?
            @category_name = "[None]";
        end

        # Get the associated event:
        event_id = @time_record.event_id;

        puts("Event ID found in time_record: " + event_id.to_s);

        @event = Event.find(event_id);

        puts("Event OBJECT found in time_record: " + @event.name);

        # Get the associated event:
        volunteer_id = @time_record.volunteer_id;

        puts("Volunteer ID found in time_record: " + volunteer_id.to_s);

        @volunteer = Volunteer.find(volunteer_id);

        puts("Volunteer OBJECT found in time_record: " + @volunteer.email_address);
    end

    # Called when rendering the New TimeRecord page:
    def new
        # Check if can create a Time Record yet:
        # Check if there are any Events or Volunteers yet:
        if Event.count < 1 || Volunteer.count < 1
          render 'warn_cannot_add'
        end

        # Create a new time_record instance that will be used in the form:
        @time_record = TimeRecord.new;

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

    end

    # Called when the New TimeRecord form is submitted:
    def create
        # Create a new time_record instance that will be used in the form:
        @time_record = TimeRecord.new(time_record_params);

        if(@time_record.save)
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Time Record created successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @time_record;
        else
            # If validations prtime_recorded save, reload form (with error message):
            render 'new';
        end
    end

    # Called when rendering the Edit TimeRecord page:
    def edit
        # Get the time_record object that was selected:
        @time_record = TimeRecord.find(params[:id]);

        # Get all volunteer and event records for the form selection:
        @volunteers = Volunteer.all;
        @events = Event.all;

        # Set the default selected event & volunteer in the form:
        @selected_event = Event.find(@time_record.event_id);
        @selected_volunteer = Volunteer.find(@time_record.volunteer_id);
    end

    # Called when the Edit TimeRecord form is submitted:
    def update
        # Get the time_record object that was selected:
        @time_record = TimeRecord.find(params[:id]);

        if(@time_record.update(time_record_params))
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Time Record updated successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @time_record;
        else
            # If validations prtime_recorded save, reload form (with error message):
            render 'edit';
        end
    end


    def delete
        @time_record = TimeRecord.find(params[:id]);
    end

    def destroy
        @time_record = TimeRecord.find(params[:id]);

        @time_record.destroy;

        # Present a 1-time flash message to the user after redirect:
        flash[:notice] = "Time Record '#{@time_record.name}' deleted successfully.";

        redirect_to(time_records_path);
    end

    private

    # Defines the acceptable fields for time_record:
    def time_record_params
        params.require(:time_record).permit(:start_time,
            :end_time, :name, :category, :notes, :event_id, :volunteer_id);
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


end
