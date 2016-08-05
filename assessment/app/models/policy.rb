module Policy
  def authorize_resource(user, resource, action)
    return true if current_user.admin?

    case resource.class.to_s
      
    when "List"
      case action
      when :show
        resource.users.include?(user)
      when :edit, :update, :destroy
        resource.permission(user) == "creator"
      end

    when "Task"
      resource.list.users.include?(user)

    when "Tag"
      case action
      when :edit, :update, :destroy
        current_user.admin?
      end

    end
  end
end
