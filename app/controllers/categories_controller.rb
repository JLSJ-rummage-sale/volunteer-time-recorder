class CategoriesController < ApplicationController
  def index
      # Get all category records from the database to display:
      @categories = Category.all;
  end

  def show
      # Get the category object that was selected:
      @category = Category.find(params[:id]);
  end

  # Called when rendering the New Category page:
  def new
      # Create a new category instance that will be used in the form:
      @category = Category.new;
  end

  # Called when the New Category form is submitted:
  def create
      # Create a new category instance that will be used in the form:
      @category = Category.new(category_params);

      if(@category.save)
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Category created successfully.";

          # If saved to DB successfully, go to show page:
          redirect_to @category;
      else
          # If validations prevented save, reload form (with error message):
          render 'new';
      end

  end

  # Called when rendering the Edit Category page:
  def edit
      # Get the category object that was selected:
      @category = Category.find(params[:id]);
  end

  # Called when the Edit Category form is submitted:
  def update
      # Get the category object that was selected:
      @category = Category.find(params[:id]);

      if(@category.update(category_params))
          # Present a 1-time flash message to the user after redirect:
          flash[:notice] = "Category updated successfully.";

          # If saved to DB successfully, go to show page:
          redirect_to @category;
      else
          # If validations prevented save, reload form (with error message):
          render 'edit';
      end
  end


  def delete
      @category = Category.find(params[:id]);

      # @volunteers_with_category = Volunteer.find_by_category_id(params[:id]);

      # TODO: Check if need to prevent / warn before deleting a Category:
      # Prevent user from deleting this Member Type if any volunteers have this member type:
      # unless @volunteers_with_category.nil?
      #   render 'warn_cannot_delete';
      # end
  end

  def destroy
      @category = Category.find(params[:id]);

      @category.destroy;

      # Present a 1-time flash message to the user after redirect:
      flash[:notice] = "Category '#{@category.name}' deleted successfully.";

      redirect_to(categories_path);
  end

  private

  # Defines the acceptable fields for category:
  def category_params
      params.require(:category).permit(:name);
  end

  def set_page_section
    @page_section = "category"
  end


end
