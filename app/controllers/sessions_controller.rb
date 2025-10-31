class SessionsController < ApplicationController
  include AuthCookies
 # class to handle user sessions with supabase authentication

  def create
    email = params[:email].to_s.strip
    password = params[:password].to_s.strip

    if email.empty? || password.empty?
    flash.now[:alert] = "Email and password are required"
    return render :new, status: :unprocessable_entity
  end

    begin
      # supabase.rb
      response = SupabaseAuth.log_in(email: email, password: password)
      # response = JSON.parse(log_in_response.body)
      # set session cookies with supabase response after login
      set_auth_cookies(
        access_token: response["access_token"],
        refresh_token: response["refresh_token"],
        expires_in: response["expires_in"]
      )
      redirect_to root_path, notice: "Logged in successfully."
    end
  
#AuthenticationError currently causing issues, commenting out for now
    #rescue SupabaseAuth::AuthenticationError => e
      #flash.now[:alert] = "Invalid email or password"
      #render :new, status: :unauthorized
    #rescue Faraday::Error => e
      #flash.now[:alert] = "An error occurred while trying to log in. Please try again."
      #render :new, status: :service_unavailable
    #rescue JSON::ParserError
      #flash.now[:alert] = "Received invalid response from authentication service"
      #render :new, status: :service_unavailable
    #end


  # Log out user by clearing auth cookies
  def destroy
    clear_auth_cookies
    redirect_to root_path, notice: "Logged out successfully."
  end

end

=begin
  Rails controller for managing user sessions w/o supabase
  layout 'login', only: [:new, :create]
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully."
  end
=end
end