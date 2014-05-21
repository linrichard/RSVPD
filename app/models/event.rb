class Event < ActiveRecord::Base
  require 'rubygems'

  STATUS_CODES = {
    :ERROR => "error",
    :SUCCESS => "success"
  }

  RSVP_STATUS = {
    :INVITED => 1,
    :ACCEPTED => 2,
    :DECLINED => 3,
    :MAYBE => 4
  }

  PRIVACY_TYPES = {
    "OPEN" => 1,
    "SECRET" => 0
  }

  # returns a response json obj
  def self.create_from_params(creator, params)
    if creator.nil?
      @error = "Invalid user"
    else
      name = params[:name]
      if name.nil?
        @error = "Event must have a name"
      end

      description = params[:description]

      # location_id = params[:location_id]
      # perhaps use yelp or something
      start_time = params[:start_time]
      if start_time.nil?
        @error = "Event must have a start time"
      else
        start_time = DateTime.iso8601(start_time)
      end

      end_time = params[:end_time]
      if end_time.present?
        end_time = DateTime.iso8601(end_time)
        if start_time >= end_time
          @error = "Event end time #{end_time} must be after start time #{start_time}"
        end
      end

      privacy = PRIVACY_TYPES[params[:privacy]]
      price = params[:price]
      phone = params[:phone]
      website = params[:website]
      rsvp_deadline = params[:rsvp_deadline]

      if rsvp_deadline.present?
        rsvp_deadline = DateTime.iso8601(rsvp_deadline)
        if rsvp_deadline > start_time - 12.hours
          @error = "RSVP deadline #{rsvp_deadline} must be at least 12 hours before the event start time #{start_time}."
        end
      end

      if @error.nil?
        @event = Event.new({
          :creator_id => creator.id,
          :name => name,
          :description => description,
          :start_time => start_time,
          :end_time => end_time,
          :rsvp_deadline => rsvp_deadline,
          :privacy => privacy,
          :price => price,
          :phone => phone,
          :website => website
        })

        unless @event.save
          @error = "There was a problem creating the event. Please try again."
        end
      end
    end

    return Event.create_response(@event, @error)
  end

  def invite(inviter, invitees)
    if inviter.id != self.creator_id
      @error = "You must be the event creator to invite people"
    end
    invitees = invitees.split(',')

    invitees.each do |number|
      logger.debug("=================================")
      logger.debug("GOING TO INVITE #{number}")
      logger.debug("=================================")
      # first see if this user is a registered user in our system
      user = User.where(:phone => number).first
      if user.nil?
        # send text to number to sign up
        account_sid = "ACeab789afb19e1f624112a07b56e3053c"
        auth_token = "0cf5deebb291b0b32fd399388fff6115"
        @client = Twilio::REST::Client.new account_sid, auth_token

        message = @client.account.messages.create(
            :body => "#{inviter.first_name} #{inviter.last_name} just invited you to their event \"#{self.name}\" on RSVPd. Click on the link: http://www.rsvpd.com. Text STOP to stop receiving notifications.",
            :to => "+1#{number}",
            :from => "+14088161040"
        )
        # puts message.to
      else
        # this user is part of our system, 
        # send notification of invitation text (if allowed in settings)
        # use parse to send push notification
      end

      EventInvite.create({
        :event_id => self.id,
        :user_id => user.present? ? user.id : nil,
        :phone => number,
        :rsvp_status => RSVP_STATUS[:INVITED]
      })
    end

    return Event.create_response(true, @error)
  end

  def self.create_response(success_obj, error_obj)
    if error_obj.present?
      status = STATUS_CODES[:ERROR]
      content = error_obj
      logger.debug("=================================")
      logger.debug("ERROR: #{@error}")
      logger.debug("=================================")
    else
      status = STATUS_CODES[:SUCCESS]
      content = success_obj
      logger.debug("=================================")
      logger.debug("SUCCESS")
      logger.debug("=================================")
    end

    response = {
      :status => status,
      :content => content
    }
    return response
  end
end
