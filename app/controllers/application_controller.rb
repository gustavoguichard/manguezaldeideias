class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :is_signed_in?, :current_user_image
  before_filter :load_pages_for_the_links
  before_filter :store_url

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_session_path, :alert => exception.message
  end

  # I couldn't get CanCan to work in this controller
  def redirect_guest
    redirect_to new_session_path if !is_signed_in? or (current_user and !current_user.approved)
  end
  
  protected
  def current_user
    @current_user ||= User.find_by_id(cookies[:user], :include => :ideas)
    #User.find(828)
  end

  def is_signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
    cookies[:user] = { :value => user.id, :expires => 30.days.from_now }
  end

  def load_pages_for_the_links
    @pages_for_links = Page.order('position, title ASC').select(['title', 'slug'])
  end

  def store_url
    session[:redirect_url] = request.url if params[:controller] != "sessions"
  end
end
