class VolunteersController < ApplicationController

    def index
        # Get all volunteer records from the database to display:

        @volunteer_total_count = Volunteer.count

        if (params[:member_type])
          @member_type_filter = MemberType.find_by_id(params[:member_type]);

          @selected_member_type_id = @member_type_filter.id
        end

        if (params[:search])
          @search_filter = params[:search].to_s.downcase;
        end

        # Check if a 'search' parameter was passed in:
        #@volunteers = Volunteer.search(@search_filter).of_member_type(params[:member_type]).sorted.page(params[:page]).per(10);
        # if params[:search]
        #     @volunteers = Volunteer.search(params[:search]).sorted.page(params[:page]).per(10); #paginate(:page => params[:page], :per_page => 10);
        # else
        #     @volunteers = Volunteer.sorted.page(params[:page]).per(10); #paginate(:page => params[:page], :per_page => 10);
        # end

        all_volunteers = Volunteer.search(@search_filter).of_member_type(params[:member_type]).sorted

        @volunteer_result_count = all_volunteers.count;

        @volunteers = all_volunteers.page(params[:page]).per(10);

        @member_types = MemberType.all

        respond_to do |format|
          format.html
          format.csv do
            all_volunteers = Volunteer.sorted
            send_data all_volunteers.as_csv
          end
        end
    end

    def show
        # Get the volunteer object that was selected:
        @volunteer = Volunteer.find(params[:id]);

        # Get the associated member type:
        @member_type = MemberType.find_by_id(@volunteer.member_type_id);

        # Get all associated PlannedShifts:
        @planned_shifts = @volunteer.planned_shifts.chronologically

        @spreadsheet = get_spreadsheet_creator_if_exists(@volunteer)
    end

    # Called when rendering the New Volunteer page:
    def new
        # Check if can create a Volunteer yet:
        # Check if there are any MemberTypes yet:
        if MemberType.count < 1
          render 'warn_cannot_add'
        end

        # Create a new volunteer instance that will be used in the form:
        @volunteer = Volunteer.new;

        # Get all member type records for the form selection:
        @member_types = MemberType.all;
    end

    # Called when the New Volunteer form is submitted:
    def create
        # Create a new volunteer instance that will be used in the form:
        @volunteer = Volunteer.new(volunteer_params);

        # Get all member type records for the form selection:
        @member_types = MemberType.all;

        if(@volunteer.save)
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Volunteer created successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @volunteer;
        else
            # If validations prevented save, reload form (with error message):
            render 'new';
        end

    end

    # Called when rendering the Edit Volunteer page:
    def edit
        # Get the volunteer object that was selected:
        @volunteer = Volunteer.find(params[:id]);

        # Get all member type records for the form selection:
        @member_types = MemberType.all;
    end

    # Called when the Edit Volunteer form is submitted:
    def update
        # Get the volunteer object that was selected:
        @volunteer = Volunteer.find(params[:id]);

        if(@volunteer.update(volunteer_params))
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Volunteer updated successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @volunteer;
        else
            # If validations prevented save, reload form (with error message):
            render 'edit';
        end
    end


    def delete
        @volunteer = Volunteer.find(params[:id]);
    end

    def destroy
        @volunteer = Volunteer.find(params[:id]);

        @volunteer.remove_spreadsheet_connection

        @volunteer.destroy;

        # Present a 1-time flash message to the user after redirect:
        flash[:notice] = "Volunteer '#{@volunteer.first_name} #{@volunteer.last_name}' deleted successfully.";

        redirect_to(volunteers_path);
    end

    private

    # Defines the acceptable fields for Volunteer:
    def volunteer_params
        params.require(:volunteer).permit(:first_name,
            :last_name,:email_address, :phone, :notes, :member_type_id);
    end

    def get_spreadsheet_creator_if_exists(volunteer)
      volunteer_import_record = VolunteersUploaded.find_by_volunteer_id(volunteer.id)

      puts "lookup volunteer_import_record = #{volunteer_import_record}"

      if (volunteer_import_record)
        puts "found volunteer_import_record.spreadsheet = #{volunteer_import_record.spreadsheet}"
        return volunteer_import_record.spreadsheet
      else
        return nil
      end
    end



    def set_page_section
      @page_section = "volunteer"
    end


end
