class CreateEnsemblePrimaryElectiveRanks < ActiveRecord::Migration
  def change
    create_table :ensemble_primary_elective_ranks do |t|
      t.integer :ensemble_primary_id
      t.integer :elective_id
      t.integer :rank

      t.timestamps
    end
  end
end
