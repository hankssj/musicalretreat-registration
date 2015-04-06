class CreateEnsemblePrimaries < ActiveRecord::Migration
  def change
    create_table :ensemble_primaries do |t|
      t.integer :registration_id
      t.integer :large_ensemble_choice     # see EnsemblePrimary.enum_name
      t.integer :chamber_ensemble_choice   # see EnsemblePrimary.enum_name
      t.integer :large_ensemble_part       # Same as chamber_ensemble_part in Evaluation.
                                           # 0,1,2 for first second or third. 10 is reserved for piccolo, 
                                           # 100 - 103 reserved for soprano,alto,tenor,baritone sax

      # These are for instruments w/o a large ensemble (currently only piano)
      t.boolean :want_sing_in_chorus
      t.boolean :want_percussion_in_band

      t.text :comments

      t.timestamps
    end
  end
end
