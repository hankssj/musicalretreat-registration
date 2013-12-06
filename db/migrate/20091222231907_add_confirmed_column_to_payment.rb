class AddConfirmedColumnToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :confirmed, :string, :default => true
  end

  def self.down
    remove_column :payments, :confirmed
  end
end
