class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    email    = user_params[:email]
    password = user_params[:password]

    begin
      # 1. Create user in Supabase Auth (this creates the actual login account)
      supabase_response = SupabaseAuth.sign_up(email: email, password: password)

      # 2. Create matching local user (your app profile)
      @user = User.new(user_params)

      if @user.save
        # 3. Do NOT auto-login. Let them log in normally through Supabase.
        redirect_to login_path, notice: "Account created! Please log in."
      else
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end

    rescue SupabaseAuth::AuthenticationError => e
      flash.now[:alert] = "Supabase signup failed: #{e.message}"
      @user = User.new(user_params)
      render :new, status: :unprocessable_entity

    rescue SupabaseAuth::ServiceError => e
      Rails.logger.error("Supabase signup service error: #{e.message}")
      flash.now[:alert] = "Authentication service error. Please try again later."
      @user = User.new(user_params)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
