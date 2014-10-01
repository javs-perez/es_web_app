require 'faker'

FactoryGirl.define do 
	factory :project do |f|
		f.name { ["Awesome Project", "Some other Awesome Project", "Another one"].sample }
		f.status { ["Approved", "New", "Pre-funding", "Funding"].sample }
		f.user_id { rand(1..1000)}
	end
end