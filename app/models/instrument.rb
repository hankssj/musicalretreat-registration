class Instrument 
  attr_reader :id, :display_name, :large_ensemble, :self_eval

  def initialize(id, display_name, large_ensemble, self_eval)
    @id = id
    @display_name = display_name
    @large_ensemble = large_ensemble
    @self_eval = self_eval
  end

  def self.menu_selection
    INSTRUMENTS.values.sort{|i1, i2| i1.display_name <=> i2.display_name}.reject{|i| CLOSED.include?(i.id)}.map{|i| [i.display_name, i.id]}
  end

  def self.find(id)
    INSTRUMENTS[id]
  end
    
  INSTRUMENTS = {
    1 => Instrument.new(1, "Voice-Soprano", :chorus, :vocal),
    2 => Instrument.new(2, "Voice-Alto", :chorus, :vocal),
    3 => Instrument.new(3, "Voice-Tenor", :chorus, :vocal),
    4 => Instrument.new(4, "Voice-Baritone", :chorus, :vocal),
    5 => Instrument.new(5, "Voice-Bass", :chorus, :vocal),
    6 => Instrument.new(6, "Violin", :orchestra, :string),
    7 => Instrument.new(7, "Viola", :orchestra, :string),
    8 => Instrument.new(8, "Cello", :orchestra, :string),
    9 => Instrument.new(9, "Double Bass", :orchestra, :string),
    10 => Instrument.new(10, "Piccolo", :band_or_orchestra, :wind),
    11 => Instrument.new(11, "Flute", :band_or_orchestra, :wind),
    12 => Instrument.new(12, "Oboe", :band_or_orchestra, :wind),
    14 => Instrument.new(14, "Bassoon", :band_or_orchestra, :wind),
    15 => Instrument.new(15, "Clarinet", :band_or_orchestra, :wind),
    16 => Instrument.new(16, "Clarinet-Bass", :band_or_orchestra, :wind),
    17 => Instrument.new(17, "Saxophone", :band, :wind),
    18 => Instrument.new(18, "Saxophone-Soprano", :band, :wind),
    19 => Instrument.new(19, "Saxophone-Alto", :band, :wind),
    20 => Instrument.new(20, "Saxophone-Tenor", :band, :wind),
    21 => Instrument.new(21, "Saxophone-Baritone", :band, :wind),
    22 => Instrument.new(22, "Trumpet", :band_or_orchestra, :brass),
    23 => Instrument.new(23, "Horn", :band_or_orchestra, :brass),
    24 => Instrument.new(24, "Trombone", :band_or_orchestra, :brass),
    25 => Instrument.new(25, "Trombone-Bass", :band_or_orchestra, :brass),
    26 => Instrument.new(26, "Euphonium", :band, :brass),
    27 => Instrument.new(27, "Tuba", :band_or_orchestra, :brass),
    28 => Instrument.new(28, "Percussion", :band_or_orchestra, :percussion),
    31 => Instrument.new(31, "Timpani", :band_or_orchestra, :percussion),
    32 => Instrument.new(32, "Harp", :band_or_orchestra, :piano),
    34 => Instrument.new(34, "Piano", :none, :piano),
    37 => Instrument.new(37, "Clarinet-Alto", :band_or_orchestra, :win)
  }

  CLOSED = []

end


  # def menu_selection
  #   a = []
  #   self.find(:all, :order => :display_name).each do |inst|
  #     if !inst.closed 
  #       a << [inst.display_name, inst.id] 
  #     end
  #   end
  #   a
  # end
