class EventController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :check_valid_params!

  def rsvp_deadline
    fb_event_id = params[:fb_event_id]
    deadline = params[:deadline]

    render :nothing => true and return if fb_event_id.blank? || deadline.blank?

    deadline_date_time = DateTime.iso8601(deadline)
    @event = Event.where(:fb_event_id => fb_event_id).first
    if @event.nil?
      # no event, so create one
      @event = Event.create(
        :fb_event_id => fb_event_id,
        :rsvp_deadline => deadline_date_time
      )
    else
      @event.update_attributes({
        :rsvp_deadline => deadline
      })
      @event.reload
    end

    respond_to do |format|
      format.html
      format.json {
        render :json => @event
      }
    end
  end

  def get_rsvp_deadline
    fb_event_id = params[:fb_event_id]
    @event = Event.where(:fb_event_id => fb_event_id).first
    if @event.nil?
      render :nothing => true and return
    end

    respond_to do |format|
      format.html
      format.json {
        render :json => @event.rsvp_deadline.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
      }
    end
  end

  def create
    current_user = User.where(:fb_user_id => params[:fb_user_id]).first
    @response = Event.create_from_params(current_user, params)

    respond_to do |format|
      format.html
      format.json {
        render :json => @response
      }
    end
  end

  def invite
    current_user = User.where(:fb_user_id => params[:fb_user_id]).first
    @event = Event.where(:id => params[:event_id]).first
    render :nothing => true and return if @event.nil?

    invitees = params[:invitees]
    @response = @event.invite(current_user, invitees)

    respond_to do |format|
      format.html
      format.json {
        render :json => @response
      }
    end
  end
end
