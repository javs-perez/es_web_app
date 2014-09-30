class Project < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, :presence => true

	STATUS = ["Approved", "New", "Pre-funding", "Funding"]

	validates_inclusion_of :status, :in => STATUS

	before_save :set_status
	after_save :publish_funding

	private

		def set_status
      @previous_status = Project.find_by(id: id).status
    end

		def publish_funding
      @user = User.find_by(id: self.user_id)

      if ((self.status == "Funding") && (@previous_status != "Funding" ))
        Publisher.publish("projects", { 
          header: {
            ref_id:       Time.now.to_i, 
            client_id:    "es_web",
            timestamp:    Time.now.utc,
            priority:     "normal",
            auth_token:   ENV["RABBITMQ_AUTH_TOKEN"] || "test_auth_token",
            event_type:   "project_status_update"
          }, 
          body: {
            user_id:      self.user_id,
            channel:      "email",
            email:        @user.email,
            user_name:    @user.name,
            user_mobile:  @user.phone
          } 
        })
      end
    end
end
