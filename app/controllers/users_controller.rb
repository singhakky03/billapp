class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.errors.present?
      render 'new'
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
    @total_bill = event_to_bills(@user)
    @current_bill = current_month_bill(@user)
    @current_paid_bill = current_month_paid_bill(@user)
    @user_paid = event_paid_amount(@user)
  end

  private

  def user_params
    params.require(:user).permit!
  end

  def event_to_bills(user)
    user.bills.pluck(:total).sum
  end

  def event_paid_amount(user)
    user.bills.pluck(:paid).sum
  end

  def current_month_bill(user)
    events = Event.from_this_month
    bill_amount = Bill.where('user_id = ? AND event_id IN (?)',user.id, events.pluck(:id)).pluck(:total).sum
  end

  def current_month_paid_bill(user)
    events = Event.from_this_month
    bill_amount = Bill.where('user_id = ? AND event_id IN (?)',user.id, events.pluck(:id)).pluck(:paid).sum
  end

end
