class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:home]

  def home
    if current_user
      redirect_to lists_path
    else
      redirect_to new_user_session_path
    end
  end
end
