class PrearrangedChamber < ActiveRecord::Base
  belongs_to :ensemble_primary
  
  def instrument_id
    instrument_id_1
  end
end
