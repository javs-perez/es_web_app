require 'spec_helper'

describe Project do 
	
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

	it "should create a project and update it correctly" do
		project = Project.new(name: "Awesome test project", status: "New", user_id: 1000 )

		expect(project.name).to 	eq("Awesome test project")
		expect(project.status).to eq("New")
		expect(project.user_id).to eq(1000)
		
		project.name = "Test Project"
		expect(project.name).to eq("Test Project")

		project.status = "Approved"
		expect(project.status).to eq("Approved")
	end


end