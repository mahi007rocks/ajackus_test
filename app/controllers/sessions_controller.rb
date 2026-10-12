class SessionsController < ApplicationController
  def create
    session[:user_id] = params[:user_id].presence || "demo_user_#{SecureRandom.hex(4)}"
    redirect_to root_path, notice: "Signed in as #{session[:user_id]}"
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Signed out"
  end
end
