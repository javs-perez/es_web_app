# making up name, status and user_id for project model
FactoryGirl.define do 
	factory :project do |f|
		f.name { ["Awesome Project", "Some other Awesome Project", "Another one", "One more Awesome Project", nil].sample }
		f.status { ["Approved", "New", "Pre-funding"].sample }
		f.user_id { rand(1000..10000)}
	end
end