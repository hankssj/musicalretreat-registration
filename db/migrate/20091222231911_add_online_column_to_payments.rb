class AddOnlineColumnToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :online, :boolean, :default => false
  end

  def self.down
    remove_column :payments, :online
  end
end
