task 'publish_messages' => :environment do
	ProjectMessage.publish_all
end