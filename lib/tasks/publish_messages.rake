task :publish_messages => :environment do
	desc "Try to publish all message that have not been sent"
	ProjectMessage.publish_all
end