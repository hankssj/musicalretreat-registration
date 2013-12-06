class AddColumnsToRegistrations < ActiveRecord::Migration

# New columns for 2012 registration
#  Need handicapped access
#  Add the following fields to the registration form and file drop:
#   -- Need handicapped access
#  -- Need airport pickup and drop-off
#   -- Request fan for non-air-conditioned room
#   -- Commemorative wine glass (drop down for quantity, adds charge of $20)
#   -- T Shirt Small and XXXL
#   -- Sunday arrival

  def self.up
    add_column :registrations, :handicapped_access, :boolean, :default => false
    add_column :registrations, :airport_pickup, :boolean, :default => false
    add_column :registrations, :fan, :boolean, :default => false
    add_column :registrations, :sunday, :boolean, :default => false
    add_column :registrations, :wine_glasses, :integer, :default => 0
    add_column :registrations, :tshirts, :integer, :default => 0
    add_column :registrations, :tshirtxxxl, :integer, :default => 0
  end

  def self.down
    remove_column :registrations, :handicapped_access
    remove_column :registrations, :airport_pickup
    remove_column :registrations, :fan
    remove_column :registrations, :sunday
    remove_column :registrations, :wine_glasses
    remove_column :registrations, :tshirts
    remove_column :registrations, :tshirtxxl
  end
end
