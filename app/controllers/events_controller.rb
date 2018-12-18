class EventsController < ApplicationController

    def index
        # Get all event records from the database to display:
        @events = Event.all;
    end

    def show
        # Get the event object that was selected:
        @event = Event.find(params[:id]);
    end

    # Called when rendering the New Event page:
    def new
        # Create a new event instance that will be used in the form:
        @event = Event.new;
    end

    # Called when the New Event form is submitted:
    def create
        # Create a new event instance that will be used in the form:
        @event = Event.new(event_params);

        if(@event.save)
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Event created successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @event;
        else
            # If validations prevented save, reload form (with error message):
            render 'new';
        end

    end

    # Called when rendering the Edit Event page:
    def edit
        # Get the event object that was selected:
        @event = Event.find(params[:id]);
    end

    # Called when the Edit Event form is submitted:
    def update
        # Get the event object that was selected:
        @event = Event.find(params[:id]);

        if(@event.update(event_params))
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Event updated successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @event;
        else
            # If validations prevented save, reload form (with error message):
            render 'edit';
        end
    end


    def delete
        @event = Event.find(params[:id]);
    end

    def destroy
        @event = Event.find(params[:id]);

        @event.destroy;

        # Present a 1-time flash message to the user after redirect:
        flash[:notice] = "Event '#{@event.name}' deleted successfully.";

        redirect_to(events_path);
    end

    private

    # Defines the acceptable fields for event:
    def event_params
        params.require(:event).permit(:name,
            :year, :description, :website);
    end

    def set_page_section
      @page_section = "event"
    end

end
