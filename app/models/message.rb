module Message
	def set_message(event_type, user_id, user_email, user_name, user_mobile)
		@message = { 
      header: {
        ref_id:       Time.now.to_i, 
        client_id:    "es_web",
        timestamp:    Time.now.utc,
        priority:     "normal",
        auth_token:   ENV["RABBITMQ_AUTH_TOKEN"] || "test_auth_token",
        event_type:   event_type
        }, 
        body: {
          user_id:      user_id,
          channel:      "email",
          email:        user_email,
          user_name:    user_name, 
          user_mobile:  user_mobile
        } 
      }
   end

end
