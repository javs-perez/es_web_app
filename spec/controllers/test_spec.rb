require 'spec_helper'

describe ProjectsController do 
	before(:all) do
		@user = User.create(name: "test dummy", phone: "305-555-5555", email: "something@something.com")
	end

	it "should create a project and notify" do 
		post :create, { project: {user_id: @user.id, status: 'Approved', name: "Test Project"} }

		expect(response.status).to eq(302)
		expect(assigns(:project).name).to 	eq("Test Project")
		expect(assigns(:project).status).to eq("Approved")	

		project_id = assigns(:project).id
		post :update, { id: project_id, project: { status: 'Funding' } }

		expect(response.status).to eq(302)	
		expect(assigns(:project).status).to eq("Funding")
	
		
	# 	connection 	= 	double('connection')
	# 	channel 		= 	double('channel')
	# 	exchange 		= 	double('exchange')
	# 	Publisher.stub(:connection) 		{ connection 	}
	# 	Publisher.stub(:create_channel) { channel 		}
	# 	Publisher.stub(:publish) 				{ exchange 		} 
	end
end
