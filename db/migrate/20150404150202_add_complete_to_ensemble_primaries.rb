class AddCompleteToEnsemblePrimaries < ActiveRecord::Migration
  def change
    add_column :ensemble_primaries, :complete, :boolean
  end
end
