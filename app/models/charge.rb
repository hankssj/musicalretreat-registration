require 'yaml'

class Charge
  @@charges = nil
  
  class << self
    def init
      unless @@charges
        @@charges ||= YAML.load_file(File.join(Rails.root, 'config', 'charges.yml'))[Year.this_year.to_i]
        @@keys = @@charges.keys.to_a
      end    
    end

    def charge_for(name)
      init
      @@charges[name]
    end

    def sort_index_for(name)
      init
      @@keys.index(name)
    end
  end
end

