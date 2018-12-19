class MemberTypesController < ApplicationController

    def index
        # Get all member_type records from the database to display:
        @member_types = MemberType.sorted;
    end

    def show
        # Get the member_type object that was selected:
        @member_type = MemberType.find(params[:id]);
    end

    # Called when rendering the New MemberType page:
    def new
        # Create a new member_type instance that will be used in the form:
        @member_type = MemberType.new;
    end

    # Called when the New MemberType form is submitted:
    def create
        # Create a new member_type instance that will be used in the form:
        @member_type = MemberType.new(member_type_params);

        if(@member_type.save)
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Member Type created successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @member_type;
        else
            # If validations prevented save, reload form (with error message):
            render 'new';
        end

    end

    # Called when rendering the Edit MemberType page:
    def edit
        # Get the member_type object that was selected:
        @member_type = MemberType.find(params[:id]);
    end

    # Called when the Edit MemberType form is submitted:
    def update
        # Get the member_type object that was selected:
        @member_type = MemberType.find(params[:id]);

        if(@member_type.update(member_type_params))
            # Present a 1-time flash message to the user after redirect:
            flash[:notice] = "Member Type updated successfully.";

            # If saved to DB successfully, go to show page:
            redirect_to @member_type;
        else
            # If validations prevented save, reload form (with error message):
            render 'edit';
        end
    end


    def delete
        @member_type = MemberType.find(params[:id]);

        @volunteers_with_member_type = Volunteer.find_by_member_type_id(params[:id]);

        # Prevent user from deleting this Member Type if any volunteers have this member type:
        unless @volunteers_with_member_type.nil?
          render 'warn_cannot_delete';
        end
    end

    def destroy
        @member_type = MemberType.find(params[:id]);

        @member_type.destroy;

        # Present a 1-time flash message to the user after redirect:
        flash[:notice] = "Member Type '#{@member_type.name}' deleted successfully.";

        redirect_to(member_types_path);
    end

    private

    # Defines the acceptable fields for member_type:
    def member_type_params
        params.require(:member_type).permit(:name,
            :details);
    end



    def set_page_section
      @page_section = "member_type"
    end


end
