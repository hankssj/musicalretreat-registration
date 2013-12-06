class AddConfirmedColumnToCancelledPayments < ActiveRecord::Migration
  def self.up
    add_column :cancelled_payments, :confirmed, :string
  end

  def self.down
    remove_column :cancelled_payments, :confirmed
  end
end
