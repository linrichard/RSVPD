class AdminController < ApplicationController
  before_filter :authenticate

  def index
    @waitlists = Waitlist.all
  end

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      # you probably want to guard against a wrong username, and encrypt the
      # password but this is the idea.
      username == "rsvpdappadmin" && password == "hellos123"
    end
  end

end
