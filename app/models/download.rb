# == Schema Information
# Schema version: 20111124000001
#
# Table name: downloads
#
#  id            :integer(4)      not null, primary key
#  download_type :string(255)
#  downloaded_at :datetime
#

class Download < ActiveRecord::Base
end
