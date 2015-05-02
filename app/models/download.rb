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
  def self.reset_to(date)
    Download.all.select{|d| d.downloaded_at > date}.each{|d| d.destroy!}
  end
end
