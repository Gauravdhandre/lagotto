class ApplicationController < ActionController::Base
  # include base controller methods

  include Authenticable

  # include helper module for DOI resolution
  include Resolvable

  #protect_from_forgery

  before_filter :miniprofiler

  layout 'application'

  after_filter :store_location

def store_location
  # store last url as long as it isn't a /users path
  session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || user_path("me") 
  end

  private

  def miniprofiler
    Rack::MiniProfiler.authorize_request if current_user && current_user.is_admin?
  end
end
