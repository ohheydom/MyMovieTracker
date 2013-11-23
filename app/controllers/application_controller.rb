class ApplicationController < ActionController::Base
	before_filter :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	require 'the_movie_db'
  
  def after_sign_in_path_for(user)
  profile_path(current_user)
  end

protected

  def configure_permitted_parameters
     devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
	 devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me) }
  end
  
end