require 'spec_helper'

describe Project do 
	it "has a valid factory" do
		FactoryGirl.create(:project).should be_valid
	end
	
	it "is invalid without a user_id" do
		FactoryGirl.build(:project, user_id: nil).should_not be_valid
	end

	it "is invalid without status been in ['Approved', 'New', 'Pre-funding', 'Funding']" do
		FactoryGirl.build(:project, status: "Not-Approved").should_not be_valid
	end

	it "is invalid without a status" do
		FactoryGirl.build(:project, status: nil).should_not be_valid
	end

	it "is valid witout a name" do
		FactoryGirl.build(:project, name: nil).should be_valid
	end
end