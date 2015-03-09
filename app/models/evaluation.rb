class Evaluation < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  def partial_name
    type.to_underscore
  end
end

class InstrumentalEvaluation < Evaluation
end

class VocalEvaluation < Evaluation
end



