require 'spec_helper'

describe Project do 
	it "has a valid factory" do
		FactoryGirl.create(:user).should be_valid
	end
	
	it "is invalid without a phone # in the following format: xxx-xxx-xxxx" do
		FactoryGirl.build(:user, phone: "568898989").should_not be_valid
	end

	it "is valid with a phone # in the following format: xxx-xxx-xxxx" do
		FactoryGirl.build(:user, phone: "685-898-8585").should be_valid
	end

	# because the app is not made available to the public making sure the email has only a '@' in it should be enought to validate it
	it "is invalid without an email string without a '@' in it" do  
		FactoryGirl.build(:user, email: "something.something.com").should_not be_valid
	end

	it "is invalid witout a name" do
		FactoryGirl.build(:user, name: nil).should_not be_valid
	end

	it "should create a user and update it correctly" do
		user = User.new(name: "Awesome User", phone: "555-555-5555", email: "something@something.com" )

		expect(user.name).to 	eq("Awesome User")
		expect(user.phone).to eq("555-555-5555")
		expect(user.email).to eq("something@something.com")
		
		user.name = "Test user"
		expect(user.name).to eq("Test user")

		user.phone = "555-555-5555"
		expect(user.phone).to eq("555-555-5555")

		user.email = "awesome@something.com"
		expect(user.email).to eq("awesome@something.com")
	end
end