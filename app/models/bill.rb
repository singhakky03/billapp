# == Schema Information
#
# Table name: bills
#
#  id         :integer          not null, primary key
#  total      :float
#  paid       :float
#  balance    :float
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_bills_on_event_id_and_user_id  (event_id,user_id)
#

class Bill < ActiveRecord::Base

  belongs_to :user
  belongs_to :event

  validates :event_id, :user_id, :total, :paid, :presence => true

  before_create :check_paid_value
  after_create :set_balance, :set_event_status

  scope :this_month_bill, -> (user_id) { where('user_id = ?', user_id).where("(created_at > ? AND created_at < ?)", Time.now.beginning_of_month, Time.now.end_of_month) }

  scope :this_month_event, -> (event_id) { where('event_id = ?', event_id).where("(created_at > ? AND created_at < ?)", Time.now.beginning_of_month, Time.now.end_of_month) }

  scope :user_bill, -> (user_id,event_id) { where('event_id = ? AND user_id = ?', event_id, user_id).first }

  def check_paid_value
    return self.total > self.paid
  end

  def set_balance
    bal = (self.total - self.paid)  if self.total > self.paid
    self.update_columns(balance: bal) if bal.present?
  end

  def set_event_status
    self.event.update_columns(status: Event::Status[0])
  end

  def self.total_bill_till_date(user_id)
    self.where('user_id = ?', user_id).pluck(:total).sum
  end



end
