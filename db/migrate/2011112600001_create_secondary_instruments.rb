class CreateSecondaryInstruments < ActiveRecord::Migration
  def self.up
    create_table :secondary_instruments do |t|
      t.integer :registration_id
      t.integer :instrument_id
      t.timestamps
    end
  end

  def self.down
    drop_table :secondary_instruments
  end
end
