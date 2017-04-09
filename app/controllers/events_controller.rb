class EventsController < ApplicationController

  def index
    @events =  Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(events_params)
    @event.save
    if @event.save
      redirect_to @event_path
    end
  end

  def show
    @event = Event.find(params[:id])
    @status = event_paid?(@event)
    @paid_by = @event.users.pluck(:name).join(',') if @status
    @users = User.all
  end

  def edit
  end

  private

  def events_params
    params.require(:event).permit!
  end

  def event_paid?(event)
    return event.status == "paid" ? true : false
  end
end
