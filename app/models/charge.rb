require 'yaml'

class Charge
  @@charges = nil
  def self.charge_for(name)
    @@charges = YAML.load_file(File.join(RAILS_ROOT, 'config', 'charges.yml')) unless @@charges
    @@charges[Year.this_year.to_i][name]
  end
end
 
