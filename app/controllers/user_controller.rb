class UserController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    fb_user_id = params[:fb_user_id]
    access_token = params[:access_token]
    first_name = params[:first_name]
    last_name = params[:last_name]
    secret = params[:secret]

    if secret != "ken"
      render :nothing => true and return
    end

    @user = User.where(:fb_user_id => fb_user_id).first
    if @user.present?
      @user.update_attributes({
        :access_token => access_token,
        :first_name => first_name,
        :last_name => last_name
      })

      @user.reload
    else
      @user = User.create(:fb_user_id => fb_user_id, :access_token => access_token)
    end
    logger.debug("user = ")
    logger.debug(@user)

    if @user.nil?
      # error creating or updating user...
      render :nothing => true and return
    end

    respond_to do |format|
      format.html
      format.json {
        render :json => @user
      }
    end
  end
end
