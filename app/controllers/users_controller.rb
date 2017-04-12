class UsersController < ApplicationController

  caches_action :index, expires_in: 1.hour

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
    @total_bill = @user.bills.pluck(:total).sum
    @user_paid = @user.bills.pluck(:paid).sum
    @current_bill = @user.current_month_total_bill
    @current_paid_bill = @user.current_month_paid_total
    @info = @user.pay_json
  end

  private

  def user_params
    params.require(:user).permit!
  end

end
