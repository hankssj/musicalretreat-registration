class RemoveDownloadedAtColumnFromRegistrationsAndPayments < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :downloaded_at
    remove_column :payments, :downloaded_at
  end

  def self.down
    add_column :registrations, :downloaded_at, :datetime
    add_column :payments, :downloaded_at, :datetime
  end
end
