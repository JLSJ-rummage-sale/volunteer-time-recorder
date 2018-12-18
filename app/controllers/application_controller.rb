class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_page_section

  private

  def set_page_section
    @page_section = "home"
  end

end
