class Elective < ActiveRecord::Base
  has_and_belongs_to_many :instruments
end
