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

  scope :from_this_month, lambda { where("date > ? AND date < ?", Time.now.beginning_of_month, Time.now.end_of_month) }

  Status = ["paid", "unpaid"]
end
