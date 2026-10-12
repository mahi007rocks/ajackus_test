class EventsController < ApplicationController
  def index
    @events = Event.upcoming.includes(:vote_count)
  end

  def show
    @event = Event.find(params[:id])
  end
end
