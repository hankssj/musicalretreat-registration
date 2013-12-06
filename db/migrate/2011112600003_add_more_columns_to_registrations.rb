class AddMoreColumnsToRegistrations < ActiveRecord::Migration

  def self.up
    add_column :registrations, :occupation, :string, :default => ""
    add_column :registrations, :share_room, :boolean, :default => false
  end

  def self.down
    remove_column :registrations, :occupation
    remove_column :registrations, :share_room
  end
end
