class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_valid_params!
    fb_user_id = params[:fb_user_id]
    access_token = params[:access_token]
    secret = params[:secret]

    if secret != "ken"
      render :nothing => true and return
    end

    @user = User.where(:fb_user_id => fb_user_id, :access_token => access_token).first
    if @user.nil?
      render :nothing => true and return
    end
  end
end
