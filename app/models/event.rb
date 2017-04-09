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


  validates :total_amount,
            :presence => true

  Status = ["paid", "unpaid"]
end
