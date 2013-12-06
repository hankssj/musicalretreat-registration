class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.string :download_type
      t.datetime :downloaded_at
    end
  end

  def self.down
    drop_table :downloads
  end
end
