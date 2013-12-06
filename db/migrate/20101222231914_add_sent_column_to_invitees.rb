class AddSentColumnToInvitees < ActiveRecord::Migration
  def self.up
    add_column :invitees, :sent, :boolean
  end

  def self.down
    remove_column :invitees, :sent
  end
end
