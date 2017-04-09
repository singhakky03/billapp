class Bill < ActiveRecord::Base

  belongs_to :user
  belongs_to :event

  validates :event_id, :user_id, :total, :paid, :presence => true

  before_create :check_paid_value
  after_create :set_balance, :set_event_status

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

end
