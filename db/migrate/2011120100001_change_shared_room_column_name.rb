class ChangeSharedRoomColumnName < ActiveRecord::Migration

  def self.up
    rename_column :registrations, :share_room, :single_room
  end

  def self.down
    rename_column :registrations, :single_room, :share_room
  end
end
