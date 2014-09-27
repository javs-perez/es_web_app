class Project < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, :presence => true

	STATUS = ["Approved", "New", "Pre-funding", "Funding"]

	validates_inclusion_of :status, :in => STATUS
end
