require 'faker'
# making up name, email and phone number for the user model
FactoryGirl.define do 
	factory :user do |f|
		f.name { Faker::Name.name }
		f.email { Faker::Internet.email }
		f.phone { "#{rand(100..999)}-#{rand(100..999)}-#{rand(1000-9999)}"}
	end
end