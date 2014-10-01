<h1>README</h1>

<p>* Ruby version 2.1.1</p>
<p>* Rails version 4.1.1</p>

<p>App to send notifications through RabbitMQ whenever a project's status changes to Funding. 
If previous status of project was funding, it does not send a notification again.</p>

<div>
<h2>Models</h2>
<div>
	<h3>Project</h3>
		<p>* status - valid values are "approved", "new", "pre-funding", and "funding"</p>
		<p>* owner - which is a User</p>
		<p>* name - added a name for the project so that they are easily visible on the UI, it does not need to be present to say a project</p>
</div>

<div>
	<h3>User</h3>
		<p>* name - name of the person that owns the project</p>
		<p>* email - to be able to easily contact them</p>
		<p>* phone_number - so that they are easily reached</p>
</div>

<div>
	<h3>Project_message</h3>
		<p>* message - this model was created to be able to keep the notifications that are not sent out due to server been down or unavailable.	(a rake task :publish_messages needs to be done before the app tries to send it again)</p>
</div>
<div>

<div>
	<h2>UI</h2>
		<p>* the UI is very simple, it has two main pages of users and projects. When looking at a user, it shows all projects connected with that user. The UI is nothing fancy, just a bit of bootstrap, but it sets up a way to view, create and update projects and users.</p>
		<p>* there is no authentication </p>
</div>

<div>
	<h2>Notification</h2>
		<p>* When a project switches into the "funding" state, a notification is sent through the RabbitMQ server. This is done through a fanout exchange which broadcasts all the messages/notification it receives to all the queues it knows.</p>
		<p>* The app takes care of the transitioning from "funding" to "funding" and does not sent a notification for this.</p>
</div>

<div>
	<h2>Notification payload</h2>
		<div>
			<h3>header</h3>
				<p>* ref_id: a unique identifier for the message. It gest the time the message is sent and make it into an integer. If the identifier needs to be more unique that can be fixed.</p>
				<p>* client_id: “es_web”, the name of the client generating this message</p>
				<p>* timestamp: message’s created_at time</p>
				<p>*	priority: default is “normal” </p>
				<p>* auth_token: an authorization token. Gave it the option to either take an environment variable or just a string if no variable is available. </p>
				<p>* event_type: “project_status_update”, the type of event being sent</p>
		</div>
		<div>
			<h3>* body</h3>
				<p>* user_id: project owner id</p>
				<p>* channel: “email”, how to notify the account managers</p>
				<p>* user_email: project owner email</p>
				<p>* user_name: project owner name</p>
				<p>* user_mobile: project owner’s phone number</p>
		</div>

	<h3>Payload format: JSON</h3>
</div>

<div>
	<h2> RabbitMQ Server </h2>
		<p>A local running RabbitMQ service was used in the dev environment and messages where sent to it. The receiver buil looked like this:</p>

```
#!/usr/bin/env ruby
# encoding: utf-8
require "bunny"

conn = Bunny.new
conn.start

ch  = conn.create_channel
x   = ch.fanout("project.projects")
q   = ch.queue("receiver.projects", exclusive: true, durable: true)

q.bind(x)
puts " [*] Waiting for logs. To exit press CTRL+C"

begin
	q.subscribe(:ack => true, :block => true) do |delivery_info, properties, body|
		puts " [x] #{body}"

 		ch.ack(delivery_info.delivery_tag)
 	end
rescue Interrupt => _
	ch.close
	conn.close
end
```
	<p>This small code plus the RabbitMQ server was used to receive the messages and make sure they were in the right format.</p>
</div>

<div>
	<h2>RabbitMQ service down or unavailable</h2>
		<p>* When the message is been published if an exception is caught, the app saves the message into the ProjectMessage model. A rake task :publish_message needs to be run for the app to try to send the message again.</p>	
</div>

<div>
	<h2>RSpec tests</h2>
		<p>* simply run rspec tests</p>
		<p>* A integration test was done to test that the creation and update of a message redirects to the right pages</p>
		<p>* Unit tests were done to make sure the project and user model where been validated correctly</p>
		<p>* The bunny gem was used for RabbitMQ and bunny_mock gem was used to test the publishing.</p>
</div>
