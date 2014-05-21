class GroupController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :check_valid_params!

  def create
    @group = Group.validate_and_create(@user, params)

    respond_to do |format|
      format.html
      format.json {
        render :json => @group
      }
    end
  end

  def get
    group_id = params[:group_id]

    @group = Group.where(:id => group_id).first

    respond_to do |format|
      format.html
      format.json {
        render :json => @group
      }
    end
  end

  def index
    group_ids = GroupUser.where(:fb_user_id => @user.fb_user_id).map(&:group_id)
    @groups = Group.where(["id in (?)", group_ids])

    respond_to do |format|
      format.html
      format.json {
        render :json => @groups
      }
    end
  end

  def members
    group_id = params[:group_id]

    @group = Group.where(:id => group_id).first

    if @group
      @group_members = @group.members
    end

    respond_to do |format|
      format.html
      format.json {
        render :json => @group_members
      }
    end
  end
end
