<h1>README</h1>

<p>* Ruby version 2.1.1</p>
<p>* Rails version 4.1.1</p>

<p>App to send notifications through RabbitMQ whenever a project's status changes to Funding. 
If previous status of project was funding, it does not send a notification again.</p>

<h2>There are three Models</h2>
<h3>Project</h3>
	<ul>
		<li>* status - valid values are "approved", "new", "pre-funding", and "funding"</li>
		<li>* owner - which is a User</li>
		<li>* name - added a name for the project so that they are easily visible on the UI, it does not need to be present to say a project</li>
	</ul>

<h3>User</h3>
	<ul>
		<li>* name - name of the person that owns the project</li>
		<li>* email - to be able to easily contact them</li>
		<li>* phone_number - so that they are easily reached</li>
	</ul>

<h3>Project_message</h3>
	<ul>
		<li>* message - this model was created to be able to keep the notifications that are not sent out due to server been down or unavailable.	(a rake task :publish_messages needs to be done before the app tries to send it again)</li>
	</ul>


<h2>UI</h2>
	<ul>
		<li>* the UI is very simple, it has two main pages of users and projects. When looking at a user, it shows all projects connected with that user. The UI is nothing fancy, just a bit of bootstrap, but it sets up a way to view, create and update projects and users.</li>
		<li>* there is no authentication </li>
	</ul>

<h2>Notification</h2>
	<ul>
		<li>* When a project switches into the "funding" state, a notification is sent through the RabbitMQ server. This is done through a fanout exchange which broadcasts all the messages/notification it receives to all the queues it knows.</li>
		<li>* The app takes care of the transitioning from "funding" to "funding" and does not sent a notification for this.</li>
	</ul>

<h2>Notification payload</h2>
	<ul>
		<li>* header</li>
			<ul>
				<li>* ref_id: a unique identifier for the message. It gest the time the message is sent and make it into an integer. If the identifier needs to be more unique that can be fixed.</li>
				<li>* client_id: “es_web”, the name of the client generating this message</li>
				<li>* timestamp: message’s created_at time</li>
				<li>*	priority: default is “normal” </li>
				<li>* auth_token: an authorization token. Gave it the option to either take an environment variable or just a string if no variable is available. </li>
				<li>* event_type: “project_status_update”, the type of event being sent</li>
			</ul>
		<li>* body</li>
			<ul>
			<li>* user_id: project owner id</li>
			<li>* channel: “email”, how to notify the account managers</li>
			<li>* user_email: project owner email</li>
			<li>* user_name: project owner name</li>
			<li>* user_mobile: project owner’s phone number</li>
			</ul>
	</ul>
<h3>Payload format: JSON</h3>

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

<h2>RabbitMQ service down or unavailable</h2>
	<ul>
		<li>* When the message is been published if an exception is caught, the app saves the message into the ProjectMessage model. A rake task :publish_message needs to be run for the app to try to send the message again.</li>
	</ul>

<h2>RSpec tests</h2>
	<ul>
		<li>* simply run rspec tests</li>
		<li>* A integration test was done to test that the creation and update of a message redirects to the right pages</li>
		<li>* Unit tests were done to make sure the project and user model where been validated correctly</li>
		<li>* The bunny gem was used for RabbitMQ and bunny_mock gem was used to test the publishing.</li>
	</ul>

