class Evaluation < ActiveRecord::Base
  belongs_to :ensemble_primary
end

class StringEvaluation < Evaluation
end

class BrassEvaluation < Evaluation
end

class WindEvaluation < Evaluation
end

class VocalEvaluation < Evaluation
end

class PercussionEvaluation < Evaluation
end

class PianoEvaluation < Evaluation
end



