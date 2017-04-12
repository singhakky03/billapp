# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :bills
  has_many :events, :through => :bills

  validates :name,
            :length => { :minimum => 2, :maximum => 22,
            :message=> "Please enter user name." },
            :presence => true

  def current_month_total_bill
    events = current_month_event
    Bill.this_month_bill(self.id).where('event_id IN (?)', events).pluck(:total).sum
  end

  def current_month_paid_total
    events = current_month_event
    Bill.this_month_bill(self.id).where('event_id IN (?)', events).pluck(:paid).sum
  end

  # def is_amount_paid?
  #   total_bill = self.current_month_total_bill
  #   user_paid = self.current_month_paid_total
  #   return true if (total_bill/2) > user_paid
  # end

  def pay_json
    events =  self.events.from_this_month
    month_cal = self.month_bill_cal(events)
    self.settlement(month_cal)
  end

  def settlement(txns)
    settlement = {}
    settled = []
    txns.each do |txn|
     p = txn.keys.first
     amount = 0
     detail = txn.values.first
     pay = false
     if detail.keys.first == :pay_to
       amount = detail.values.first
     elsif detail.keys.first == :take
       amount = -detail.values.first
     end
     settlement[p] = (settlement[p]||0) + amount
    end
    settlement.each do |k,v|
      settled << "You have to pay #{k} $ #{v}" if v > 0
      settled << "#{k} will pay you $ #{v.abs}" if v < 0
    end
    settled
  end

  def month_bill_cal(details)
    arr = []
    details.each do |detail|
      average =  detail.total_amount/detail.users.count
      detail.users.each do |user|
        json = {}
        if user != self
          user_bill = detail.bills.where('user_id = ?', user.id).first.paid
          your_bill = detail.bills.where('user_id = ?', self.id).first.paid
          if (average > your_bill) && (your_bill < user_bill)
            pay = average - your_bill
            json[user.name] = {:pay_to => pay}
          elsif (average > user_bill) && (your_bill > user_bill)
            pay = average - user_bill
            json[user.name] = {:take => pay}
          end
        end
        arr << json if !json.blank?
      end
    end
    arr
  end

  private

  def current_month_event
    Event.from_this_month
  end



end
