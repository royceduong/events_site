class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  def current_event
    Event.find(params[:event_id]) if params[:event_id]
  end
  def logout
    session.clear
    puts "cleared session"
    redirect_to "/"
  end
end
