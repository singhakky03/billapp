class User < ActiveRecord::Base
  has_many :bills
  has_many :events, :through => :bills

  validates :name,
            :length => { :minimum => 2, :maximum => 22,
            :message=> "Please enter user name." },
            :presence => true
end
