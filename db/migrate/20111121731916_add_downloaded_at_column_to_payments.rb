class AddDownloadedAtColumnToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :downloaded_at, :datetime
  end

  def self.down
    remove_column :payments, :downloaded_at
  end
end
