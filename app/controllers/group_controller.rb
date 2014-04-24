class GroupController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
      logger.debug("create")
    fb_user_id = params[:fb_user_id]
    access_token = params[:access_token]
    secret = params[:secret]

    if secret != "ken"
      logger.debug("no secret")
      render :nothing => true and return
    end

    @user = User.where(:fb_user_id => fb_user_id, :access_token => access_token).first
    if @user.nil?
      logger.debug("no user")
      render :nothing => true and return
    end

    @group = Group.validate_and_create(@user, params)

    respond_to do |format|
      format.html
      format.json {
        render :json => @group
      }
    end
  end
end
