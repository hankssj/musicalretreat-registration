class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :ensemble_primary_id
      t.integer :instrument_id
      t.string :type
      t.integer :experience

      t.timestamps
    end
  end
end
