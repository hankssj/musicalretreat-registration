# Just change the name of Bass Clarinet to Clarinet - Bass
class AdjustInstrumentsAgain < ActiveRecord::Migration

  def self.up
    ii = Instrument.find_by_display_name("Bass Clarinet")
    ii.display_name = "Clarinet - Bass"
    ii.save!
  end

  def self.down
    ii = Instrument.find_by_display_name("Clarinet - Bass")
    ii.display_name = "Bass Clarinet"
    ii.save!
  end
end

