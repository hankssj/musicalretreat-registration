class Instrument < ActiveRecord::Base
  has_and_belongs_to_many :electives
  has_many :mmr_chambers

  scope :unclosed, lambda { where(closed: false) }
  def vocal?; instrument_type == "vocal"; end
  def instrumental?; !vocal?; end
  def string?; instrument_type == "string"; end
  def brass?; instrument_type == "brass"; end
  def woodwind?; instrument_type == "woodwind"; end
  def percussion?; instrument_type == "percussion"; end
  def piano?; id == 34; end

  def violin?; id == 6; end
  def viola?; id == 7; end
  def cello?; id == 8; end
  def bass?; id == 9; end

  def doubled_parts?;  violin? || viola? || cello?; end

  def flute?; id == 10 || id == 11; end
  def clarinet?; id == 15 || id == 16 || id == 37; end
  def oboe?; id == 12; end
  def bassoon?; id == 14; end
  def horn?; id == 23; end
  def trumpet?; id == 22; end
  def trombone?; id == 24 || id == 25; end
  def saxophone?; id >= 17 && id <= 21; end
  def saxophone_nonspecific?; id == 17; end

  def jazz?; [9, 15, 17, 18, 19, 20, 21, 22, 24, 25, 27, 28, 34].include?(id); end

  def self.menu_selection
    menu_helper(Instrument.all.reject{|i| i.closed})
  end

  # Include only the selections linked to the elective_id
  def self.menu_selection_for_elective(elective)
    menu_helper(elective.instruments)
  end

  private
  def self.menu_helper(list_of_instruments)
    list_of_instruments.sort{|i1, i2| i1.display_name <=> i2.display_name}.map{|i| [i.display_name, i.id]}
  end
end
