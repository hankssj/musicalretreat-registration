#  Need to adjust data in instruments table, which as far as I can tell, was manually created.
#  Need to do so without destroying the IDs of current instruments.
#    *  add Accompanist
#    *  add Clarinet - Alto
#    *  add Recorder
#    *  change French Horn to Horn

# +----+----------------------+--------+------------+------------+
# | id | display_name         | closed | created_at | updated_at |
# +----+----------------------+--------+------------+------------+
# |  1 | Voice - Soprano      |      0 | NULL       | NULL       |
# |  2 | Voice - Alto         |      0 | NULL       | NULL       |
# |  3 | Voice - Tenor        |      0 | NULL       | NULL       |
# |  4 | Voice - Baritone     |      0 | NULL       | NULL       |
# |  5 | Voice - Bass         |      0 | NULL       | NULL       |
# |  6 | Violin               |      0 | NULL       | NULL       |
# |  7 | Viola                |      0 | NULL       | NULL       |
# |  8 | Cello                |      0 | NULL       | NULL       |
# |  9 | Double Bass          |      0 | NULL       | NULL       |
# | 10 | Piccolo              |      0 | NULL       | NULL       |
# | 11 | Flute                |      0 | NULL       | NULL       |
# | 12 | Oboe                 |      0 | NULL       | NULL       |
# | 13 | English Horn         |      0 | NULL       | NULL       |
# | 14 | Bassoon              |      0 | NULL       | NULL       |
# | 15 | Clarinet             |      0 | NULL       | NULL       |
# | 16 | Bass Clarinet        |      0 | NULL       | NULL       |
# | 17 | Saxophone            |      0 | NULL       | NULL       |
# | 18 | Saxophone - Soprano  |      0 | NULL       | NULL       |
# | 19 | Saxophone - Alto     |      0 | NULL       | NULL       |
# | 20 | Saxophone - Tenor    |      0 | NULL       | NULL       |
# | 21 | Saxophone - Baritone |      0 | NULL       | NULL       |
# | 22 | Trumpet              |      0 | NULL       | NULL       |
# | 23 | French Horn          |      0 | NULL       | NULL       |
# | 24 | Trombone             |      0 | NULL       | NULL       |
# | 25 | Trombone - Bass      |      0 | NULL       | NULL       |
# | 26 | Euphonium            |      0 | NULL       | NULL       |
# | 27 | Tuba                 |      0 | NULL       | NULL       |
# | 28 | Percussion           |      0 | NULL       | NULL       |
# | 29 | Snare Drum           |      0 | NULL       | NULL       |
# | 30 | Mallets              |      0 | NULL       | NULL       |
# | 31 | Timpani              |      0 | NULL       | NULL       |
# | 32 | Harp                 |      0 | NULL       | NULL       |
# | 33 | Organ                |      0 | NULL       | NULL       |
# | 34 | Piano                |      0 | NULL       | NULL       |
# | 35 | Guitar               |      0 | NULL       | NULL       |
# +----+----------------------+--------+------------+------------+


class AdjustInstruments < ActiveRecord::Migration

  def self.new_fields
    ["Accompanist", "Clarinet - Alto", "Recorder"]
  end

  def self.up
    self.new_fields.each{|f| Instrument.create(:display_name => f)}
    ii = Instrument.find_by_display_name("French Horn")
    ii.display_name = "Horn"
    ii.save!
  end

  def self.down
    self.new_fields.each{|f| ii = Instrument.find_by_display_name(f); ii.destroy}
    ii = Instrument.find_by_display_name("Horn")
    ii.display_name = "French Horn"
    ii.save!
  end
end

