# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c8d3e1fdb76de23f169ff126ea03a647'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  before_filter :set_is_admin

  def is_admin?
    session[:is_admin]
  end

  def set_is_admin
    @is_admin = is_admin?
  end

  def render_not_found message='Page not found.'
    render :text => message, :status => :not_found
  end
end
