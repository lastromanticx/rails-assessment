class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def authorize_resource(resource, action)
    case resource.class.to_s
    when "List"
      case action
      when :show
        resource.users.include?(current_user) ? true : false
      when :edit, :update, :destroy
        resource.user_lists.where(user_id: current_user.id).first.permission == "creator" ? true : false
      end

    when "Task"
      case action
      when :show, :edit, :update
        resource.list.users.include?(current_user) ? true : false
      when :destroy
        resource.list.user_lists.where(user_id: current_user.id).first.permission == "creator" ? true : false
      end

    when "Tag"
      case action
      when :edit, :update, :destroy
        current_user.admin?
      end

    end
  end
end
