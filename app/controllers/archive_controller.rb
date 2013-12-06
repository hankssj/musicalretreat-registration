class ArchiveController < ApplicationController

	before_filter :authorize_admin

	def self.archive_root
		@@ARCHIVE_ROOT
	end
	
	def index
		@archive_entries = ArchiveEntry.find(:all)
	end

	def new
		@archive_entry = ArchiveEntry.new()
	end

	def create
		@archive_entry = ArchiveEntry.new(params[:archive_entry])
		if @archive_entry.save!
			redirect_to :action => :index
		else
			flash[:message] = "File save failed!"
			redirect_to :action => :new
		end
	end
	
	def download
		send_file ArchiveEntry.find(params[:id]).full_path
	end
		

end

