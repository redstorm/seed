class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  include RoleRequirementSystem
  include ExceptionNotifiable
  include SeedAccessRights

  helper :all # include all helpers, all the time
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  before_filter :set_locale
  
  protected
  
  def set_locale
    default_locale = 'en-US'
    request_language = request.env['HTTP_ACCEPT_LANGUAGE']
    request_language = request_language.nil? ? nil : 
      request_language[/[^,;]+/]
  
    @current_locale = params[:locale] || session[:locale] ||
              request_language || default_locale
    session[:locale] = @current_locale
    begin
      I18n.locale = @current_locale.to_s
    rescue
      I18n.locale = default_locale.to_s
    end
  end
  
  #def pages_menu
  #  pages = Page.all_menu_pages
  #  grouped_pages = pages.group_by { |p| p[:menu_type] }
  #  @primary_pages = grouped_pages["primary"]
  #  @secondary_pages = grouped_pages["secondary"]
  #end
  
  def get_page
    #@page = Rails.cache.fetch("Page#{params[:page_id]}") {Page.find(params[:page_id])}
    @page ||= Page.find(params[:page_id])
  end
  
end
