class WaitlistController < ApplicationController
  protect_from_forgery except: :enlist
  skip_before_action :verify_authenticity_token

  def enlist
    email = params[:email]
    waitlist = Waitlist.where(:email => email).first

    if waitlist.present?
      @message = "You're already in line! Stay tuned for our invitation"
      @status = 1
    else
      waitlist = Waitlist.enlist(email)

      if waitlist.nil?
        @message = "You must provide a valid email address"
        @status = 0
      else
        @message = "Thanks for your interest! We'll let you know as soon as we open"
        @status = 1
      end
    end

    @data = {
      message: @message,
      status: @status
    }

    respond_to do |format|
      format.html
      format.json {
        render :json => @data
      }
    end
  end
end
