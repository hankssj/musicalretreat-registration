class CreateEnsemblePrimaries < ActiveRecord::Migration
  def change
    create_table :ensemble_primaries do |t|
      t.int :registration_id
      t.int :large_ensemble_choice
      t.int :chamber_ensemble_choice
      t.boolean :ack_no_morning_ensemble
      t.boolean :want_sing_in_chorus
      t.boolean :want_percussion_in_band

      t.timestamps
    end
  end
end
