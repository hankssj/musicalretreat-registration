class RemoveInstrumentHyphens < ActiveRecord::Migration

  def self.up
    Instrument.find(:all).each{|ii| ii.display_name = ii.display_name.gsub(" - ", "-"); ii.save!}
  end

  def self.down
    Instrument.find(:all).each{|ii| ii.display_name = ii.display_name.gsub("-", " - "); ii.save!}
  end
end

