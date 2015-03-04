create table ensemble_primaries (id int(11) primary key auto_increment, registration_id int(11) not null, primary_instrument_id int(11) not null, large_ensemble_choice int(11) not null, chamber_ensemble_choice int(11) not null, created_at datetime, updated_at datetime);

class CreateEnsemblePrimaries < ActiveRecord::Migration
  def change
    create_table :ensemble_primaries do |t|
      t.int :registration_id
      t.int :primary_instrument_id
      t.int :large_ensemble_choice
      t.string :chamber_ensemble_choice
      t.string :int

      t.timestamps
    end
  end
end
