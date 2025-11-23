class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unauthorized
    end
  end

  def destroy
    session.clear
    redirect_to root_path, notice: "Logged out successfully."
  end
end
