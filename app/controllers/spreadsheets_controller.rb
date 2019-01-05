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

    CSV.foreach(file.path, headers: true) do |row|

      puts "row = #{row}"

      puts "row.to_hash = #{row.to_hash}"

      puts "row.to_hash['Email'] = #{row.to_hash['Email']}"
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

end
