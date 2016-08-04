class ApplicationController < ActionController::Base
  include Policy

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
