class EnsemblePrimary < ActiveRecord::Base
  belongs_to :registration
  has_many :mmr_chambers
  has_many :preselect_chambers
  accepts_nested_attributes_for :mmr_chambers
  accepts_nested_attributes_for :preselect_chambers
end
