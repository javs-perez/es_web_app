class User < ActiveRecord::Base
	has_many :projects

	validates :phone, format: { with: /\d{3}-\d{3}-\d{4}/, message: "please use xxx-xxx-xxxx format"}
	validates :email, format: { with: /@/, message: "please enter a correct email address" }
	validates :name, :presence => { :message => "Name cannot be blank" }
end
