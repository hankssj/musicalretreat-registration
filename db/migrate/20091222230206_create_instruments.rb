class CreateInstruments < ActiveRecord::Migration
  def self.up
    create_table :instruments do |t|
      t.string :display_name,   :null => false
      t.boolean :closed,        :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :instruments
  end
end
