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

    @file_name = "[Unset name]"

    puts "params[:uploaded_file] = #{params[:uploaded_file].to_s}"

    if (params[:uploaded_file])
      file_uploaded = params[:uploaded_file]

      puts "file_uploaded.class.name = #{file_uploaded.class.name}"

      puts "file_uploaded.path = #{file_uploaded.path}"

      parse_file(file_uploaded)

      @file_name = file_uploaded.original_filename

    else
      puts "ISSUE: No params[:file]"
    end

    flash[:notice] = "File uploaded successfully. File Name: #{@file_name}";
    redirect_to spreadsheets_path
  end



  private

  def parse_file(file)

    puts "Parsing file..."

    error_rows = []
    volunteers_created = []

    CSV.foreach(file.path, headers: true) do |row|

      row_fields = row.to_hash

      puts "row_fields = #{row_fields}"

      last_name = row_fields["Last Name"]
      first_name = row_fields["First Name"]
      email = row_fields["Email"]

      existing_volunteer = Volunteer.find_by_email_address(email)

      puts "existing_volunteer = #{existing_volunteer.to_s}"

      if (existing_volunteer)
        puts "Volunteer already exists: #{first_name} #{last_name}, #{email}"
      else
        puts "Will CREATE Volunteer: #{first_name} #{last_name}, #{email}"

        new_volunteer = Volunteer.new(first_name: first_name, last_name: last_name, email_address: email)

        if (new_volunteer.save)
          volunteers_created << new_volunteer
        else
          error_rows << row_fields
        end
      end


      puts "volunteers_created = #{volunteers_created}"

      puts "error_rows = #{error_rows}"

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

end
