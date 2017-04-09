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
    details = users_this_month_with_you(@user)
    @info = pay_arr(@user, details).reject { |c| c.empty? }
  end

  private

  def user_params
    params.require(:user).permit!
  end

  def event_to_bills(user)
    user.bills.pluck(:total).sum
  end

  def this_month_events
    Event.from_this_month
  end

  def event_paid_amount(user)
    user.bills.pluck(:paid).sum
  end

  def current_month_bill(user)
    events = this_month_events
    bill_amount = Bill.where('user_id = ? AND event_id IN (?)',user.id, events.pluck(:id)).pluck(:total).sum
  end

  def current_month_paid_bill(user)
    events = this_month_events
    bill_amount = Bill.where('user_id = ? AND event_id IN (?)',user.id, events.pluck(:id)).pluck(:paid).sum
  end

  def is_amount_paid?(user)
    total_bill = current_month_bill(user)
    user_paid = current_month_paid_bill(user)
    return true if (total_bill/2) > user_paid
  end

  def users_this_month_with_you(user)
    json = {}
    events = this_month_events.pluck(:id)
    users = Bill.where('event_id IN (?)', events).pluck(:user_id)
    users.each do |usr|
      u= User.find(usr)
      bill = Bill.where('user_id = ? AND event_id IN (?)', usr, events)
      json[usr] = {
        total: bill.pluck(:total).sum, paid: bill.pluck(:paid).sum, balance: bill.pluck(:balance).sum , event: u.events.pluck(:id)}
    end
    json
  end

  def pay_arr(user, details)
    arr = []
    details.each do |detail|
      pay = {}
      usr = User.find(detail[0])
      if usr != user
        total = detail[1][:total]
        my_bills = user.bills.where('event_id IN (?)',detail[1][:event]).pluck(:paid).sum
        other_bills = usr.bills.where('event_id IN (?)',detail[1][:event]).pluck(:paid).sum
        if (total/2) > my_bills
          pay[:to] = usr.name
          pay[:amount] = (total/2) - my_bills
        elsif (total/2) < my_bills
          pay[:by] = usr.name
          pay[:amount] = (total/2) - other_bills
        end
      end
      arr << pay
    end
    arr
  end

end
