class QuotasController < ApplicationController

  # Before-Actions: (These will be executed before any public action below)
  before_action :find_parent_member_type, :only => [:index, :new];
  before_action :set_member_type_list, :only => [:new, :create];

  def index
      # Get all quota records from the database to display:
      @quotas = Quota.all;
  end

  def show
      # Get the quota object that was selected:
      @quota = Quota.find(params[:id]);
  end

  # Called when rendering the New Quota page:
  def new
      # Create a new quota instance that will be used in the form:
      @quota = Quota.new;

      # Get all category records for the form selection:
      @categories = Category.all;

      # Get preselected Category:
      @selected_category = Category.first;
  end

  # Called when the New Quota form is submitted:
  def create
      # Create a new quota instance that will be used in the form:
      @quota = Quota.new(quota_params);

      if(@quota.save)
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Quota created successfully.";

          # If saved to DB successfully, go to show page:
          redirect_to @quota;
      else
          # If validations prevented save, reload form (with error message):
          render 'new';
      end

  end

  # Called when rendering the Edit Quota page:
  def edit
      # Get the quota object that was selected:
      @quota = Quota.find(params[:id]);

      # Get all category records for the form selection:
      @categories = Category.all;
      # Get preselected Category:
      @selected_category = Category.first;
      if (@quota.category) # Check if variable exists and is not nil.
          @selected_category = @quota.category;
      end

      # Get all member type records for the form selection:
      @member_types = MemberType.all;
      # Get preselected Category:
      @selected_member_type = MemberType.first;
      if (@quota.member_type) # Check if variable exists and is not nil.
          @selected_member_type = @quota.member_type;
      end
  end

  # Called when the Edit Quota form is submitted:
  def update
      # Get the quota object that was selected:
      @quota = Quota.find(params[:id]);

      if(@quota.update(quota_params))
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Quota updated successfully.";

          # If saved to DB successfully, go to show page:
          redirect_to @quota;
      else
          # If validations prevented save, reload form (with error message):
          render 'edit';
      end
  end


  def delete
      @quota = Quota.find(params[:id]);

      # @volunteers_with_quota = Volunteer.find_by_quota_id(params[:id]);

      # TODO: Check if need to prevent / warn before deleting a Quota:
      # Prevent user from deleting this Member Type if any volunteers have this member type:
      # unless @volunteers_with_quota.nil?
      #   render 'warn_cannot_delete';
      # end
  end

  def destroy
      @quota = Quota.find(params[:id]);

      @quota.destroy;

      # Present a 1-time flash message to the user after redirect:
      flash[:notice] = "Quota '#{@quota.name}' deleted successfully.";

      redirect_to(quotas_path);
  end

  private

  # Defines the acceptable fields for quota:
  def quota_params
      params.require(:quota).permit(:name, :hours, :category_id, :member_type_id);
  end

  # A Before-Action method to get the event passed from a different controller:
  # Sets a variable 'parent_member_type' if a member_type object was passed in:
  def find_parent_member_type
      # Find event passed in from filter:
      @parent_member_type = MemberType.find_by_id(params[:member_type_id]); # Will return an object or return nil.

      # DEBUG ONLY:
      puts("find_parent_member_type: member_type OBJECT passed in: " + @parent_member_type.to_s);

      if (@parent_member_type)
          puts("found member_type: " + @parent_member_type.name);
      else
          puts("didn't find member_type.")
      end
  end

  def set_member_type_list
    # Get all member_type records for the form selection:
    @member_types = MemberType.all;

    # Get preselected MemberType:
    if (@parent_member_type) # Check if variable exists and is not nil.
        @selected_member_type = @parent_member_type;
        puts("Set SELECTED_member_type to " + @selected_member_type.name);
    else
        @selected_member_type = MemberType.first;
    end
  end

end
