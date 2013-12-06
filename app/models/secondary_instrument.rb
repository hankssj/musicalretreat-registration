class SecondaryInstrument < ActiveRecord::Base
  belongs_to :registration
  belongs_to :instrument
end
