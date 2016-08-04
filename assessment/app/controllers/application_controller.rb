class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def authorize_resource(resource, action)
    #return true if current_user.admin?

    case resource.class.to_s
      
    when "List"
      case action
      when :show
        resource.users.include?(current_user)
      when :edit, :update, :destroy
        resource.permission(current_user) == "creator"
      end

    when "Task"
      resource.list.users.include?(current_user)

    when "Tag"
      case action
      when :edit, :update, :destroy
        current_user.admin?
      end

    end
  end
end
