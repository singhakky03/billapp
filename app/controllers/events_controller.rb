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
      redirect_to event_path(@event)
    end
  end

  def show
    @event = Event.find(params[:id])
    @status = event_paid?(@event)
    @paid_by = []
    @event.users.map{|u| @paid_by << "Paid By #{u.name} $ #{Bill.where('event_id = ? AND user_id = ?', @event.id, u.id).first.paid}"}
    #@paid_by = @event.users.pluck(:name).join(',') if @status
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
