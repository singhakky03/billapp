class BillsController < ApplicationController

  def new
  end

  def create
    @event = Event.find(params["event"].to_i)
    if validate_params_data(@event.total_amount)
      bill_detail_params.values.each do |detail|
        @bill = Bill.create(user_id: detail["user"].to_i, event_id: @event.id, total: @event.total_amount, paid: detail["amount"].to_f)
      end
      redirect_to root_path
    end
  end

  def show
  end

  private

  def bill_detail_params
    params.require(:details).permit!
  end

  def validate_params_data(event_amount)
    verify_amount = []
    bill_detail_params.values.each do |detail|
      amount_check = (event_amount > detail["amount"].to_f) ? true : false
      verify_amount << amount_check
    end
    return verify_amount.exclude?(false)
  end

end
