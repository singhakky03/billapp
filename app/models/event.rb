# == Schema Information
#
# Table name: events
#
#  id            :integer          not null, primary key
#  name          :string(25)
#  location      :string(25)
#  total_amount  :float
#  date          :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  special_event :boolean
#  status        :string(255)
#

class Event < ActiveRecord::Base
  has_many :bills
  has_many :users, :through => :bills

  validates :name,
            :length => { :minimum => 2, :maximum => 22,
            :message=> "Please enter event name." },
            :presence => true

  validates :location,
            :length => { :minimum => 2, :maximum => 22,
            :message=> "Please enter event location." },
            :presence => true


  validates :total_amount, :date, :presence => true

  scope :from_this_month, lambda { where("date > ? AND date < ?", Time.now.beginning_of_month, Time.now.end_of_month).where(status: "paid") }


  after_create :set_status_unpaid

  Status = ["paid", "unpaid"]

  def set_status_unpaid
    self.update_columns(status: Event::Status[1])
  end

end
