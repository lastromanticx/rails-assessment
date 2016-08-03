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
      when :edit, :show
        resource.users.include?(current_user) ? true : false
      when :destroy
        l.user_lists.where(user_id: u.id)[0].permission == "creator" ? true : false
      end

    when "Task"
      case action
      when :edit, :show
        resource.list.users.include?(current_user) ? true : false
      end

    when "Tag"
      case action
      when :destroy, :edit
        current_user.admin?
      end

    end
  end
end
