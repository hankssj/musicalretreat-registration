class AddDownloadedAtColumnToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :downloaded_at, :datetime
  end

  def self.down
    remove_column :registrations, :downloaded_at
  end
end
