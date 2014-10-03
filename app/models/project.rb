class Project < ActiveRecord::Base
  include Message 
	belongs_to :user
  # created a model of project_messages for messages that are not delivered to be delivered at a later time
  has_many :project_messages

  default_scope -> { order('created_at DESC') }
  # every project must have an owner
  validates :user_id, :presence => true

  # only 4 status are allowed
  STATUS = ["Approved", "New", "Pre-funding", "Funding"]
  validates_inclusion_of :status, :in => STATUS

  before_save :set_status
  after_save :publish_funding

  private

  # setting the status before saving an update action to check that a funding notification does not get sent twice
  def set_status
    if id
      @previous_status = Project.find_by(id: id).status
    end
  end

  # method for the notification it takes into account current status and previous status before sending a notification
  # with all the information needed. 
  # ref_id is a unique identifier by grabbing the time at the moment of the message and making it an integer
  # we can make it more unique if we need to.
  # auth_token is string for the moment until an environment variable is saved under "RABBITMQ_AUTH_TOKEN"
  def publish_funding
  @user   = User.find_by(id: self.user_id)
  @id     = self.user_id
  @email  = @user.email
  @name   = @user.name
  @phone  = @user.phone

  if ((self.status == "Funding") && (@previous_status != "Funding" ))
    set_message("project_status_update", @id, @email, @name, @phone)

      # rescues an exception of the message cannot be delivered and saves the message to the database
      # to be sent at a later time through a rake task
      begin
        Publisher.publish("projects", @message )
      rescue Bunny::Exception 
        project_messages.create!(message: @message.to_json)
      end
    
    end
  end
end


  #   message = { 
  #     header: {
  #       ref_id:       Time.now.to_i, 
  #       client_id:    "es_web",
  #       timestamp:    Time.now.utc,
  #       priority:     "normal",
  #       auth_token:   ENV["RABBITMQ_AUTH_TOKEN"] || "test_auth_token",
  #       event_type:   "project_status_update"
  #       }, 
  #       body: {
  #         user_id:      self.user_id,
  #         channel:      "email",
  #         email:        @user.email,
  #         user_name:    @user.name,
  #         user_mobile:  @user.phone
  #       } 
  #     }