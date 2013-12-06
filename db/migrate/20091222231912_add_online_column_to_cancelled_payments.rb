class AddOnlineColumnToCancelledPayments < ActiveRecord::Migration
  def self.up
    add_column :cancelled_payments, :online, :boolean, :default => false
  end

  def self.down
    remove_column :cancelled_payments, :online
  end
end
