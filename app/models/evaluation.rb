class Evaluation < ActiveRecord::Base
  belongs_to :ensemble_primary
  belongs_to :instrument

  def partial_name
    type.underscore
  end

  ENUM_TEXT = {
    :chamber_ensemble_part => ["First", "Second", "No Preference"],
    :practicing_how_much => ["Rarely", "2 or 3 times a week", "4 or more times a week"],
    :overall_rating_sightreading => ["Poor", "Average", "Good", "Excellent"],
    :chamber_music_how_often => ["Less than once a week", "Weekly", "More than once a week"],
    :overall_rating_large_ensemble => ["Beginner", "Novice", "Intermediate", "Experienced", "Advanced"],
    :overall_rating_chamber => ["Beginner", "Novice", "Intermediate", "Experienced", "Advanced"],
    :overall_rating_sightreading => ["Poor", "Average", "Good", "Excellent"],
    :vocal_overall_ability => ["Beginner", "Intermediate", "Experienced", "Advanced"],
    :vocal_how_learn => ["Reading the music", "By ear, with repetition"],
    :vocal_small_ensemble_skills => ["Prefer to sing with others, accompanied", 
                                     "Prefer to sing with others, with or without accompaniment",
                                     "Can handle your own part, without accompaniment"],
  }

  OTHER_INSTRUMENT_TEXT = {
    :other_instrument_oboe => "Oboe",
    :other_instrument_english_horn => "English Horn",
    :other_instrument_trombone => "Trombone",
    :other_instrument_bass_trombone    => "Bass Trombone",
    :other_instrument_bb_trumpet => "B-Flat Trumpet",
    :other_instrument_c_trumpet => "C Trumpet",
    :other_instrument_piccolo_trumpet  => "Piccolo Trumpet",
    :other_instrument_saxophone_soprano   => "Soprano Sax",
    :other_instrument_saxophone_alto => "Alto Sax",
    :other_instrument_saxophone_tenor  => "Tenor Sax",
    :other_instrument_saxophone_baritone  => "Baritone Sax",
    :other_instrument_bb_clarinet => "B-Flat Clarinet",
    :other_instrument_a_clarinet       => "A Clarinet",
    :other_instrument_eb_clarinet => "E-Flat Clarinet",
    :other_instrument_alto_clarinet => "Alto Clarinet",
    :other_instrument_bass_clarinet => "Bass Clarinet",
    :other_instrument_c_flute => "C Flute",
    :other_instrument_piccolo => "Piccolo",
    :other_instrument_alto_flute => "Alto Flute",
    :other_instrument_bass_flute => "Bass Flute",
    :other_instrument_drum_set => "Drum Set",
    :other_instrument_mallets => "Mallets",
    :other_instrument_bassoon_contrabassoon  => "Contrabassoon",
    :percussion_snare => "Snare",
    :percussion_timpani  => "Timpani",
    :percussion_mallets => "Mallets",
    :percussion_small_instruments => "Percussion-Small Instruments",
    :percussion_drum_set => "Drum Set",
  }

  POSITION_TEXT = {
    :third_position => "Third Position", 
    :fourth_position => "Fourth Position", 
    :fifth_position => "Fifth Position", 
    :sixth_position => "Sixth Position", 
    :seventh_position => "Seventh Position", 
    :thumb_position => "Thumb Position",
  }

  JAZZ_TEXT = {
    :jazz_want_ensemble  => "Request jazz ensemble",
    :jazz_small_ensemble => "Jazz small combo experience", 
    :jazz_big_band       => "Jazz big band experience", 
  }

  TRANSPOSITION_TEXT = {
    :trumpet => {:transposition_0 => "C", :transposition_1 => "B", :transposition_2 => "E-flat"},
    :horn    => {:transposition_0 => "E", :transposition_1 => "E-flat", :transposition_2 => "D"},
  }

  def checkbox_text(text_hash)
    text_hash.keys.map{|p| send(p) ? text_hash[p] : nil}.compact.join(", ")
  end

  def radio_button_text(att)
    return unless send(att)
    ENUM_TEXT[att][send(att)]
  end
    
  def vocal_training_text
    tt = ""
    tt +=  ("Music theory "  + (vocal_music_theory_year ? "(vocal_music_theory_year)" : "")) if vocal_music_theory
    tt +=  ("Voice lessons " + (vocal_voice_lessons ? "(vocal_voice_lessons_year)"    : "")) if vocal_voice_lessons
    tt +=  ("Voice classes " + (vocal_voice_classes ? "(vocal_voice_classes_year)"    : "")) if vocal_voice_classes
    tt
  end

  def text_for(attribute)
    case attribute
    when :transposition 
      return checkbox_text(TRANSPOSITION_TEXT[:trumpet]) if instrument.trumpet?
      return checkbox_text(TRANSPOSITION_TEXT[:horn]) if instrument.horn?
      raise "Transposition for unknown instrument"
    when :other_instruments
      checkbox_text(OTHER_INSTRUMENT_TEXT)
    when :jazz
      checkbox_text(JAZZ_TEXT)
    when :positions
      checkbox_text(POSITION_TEXT)
    when :vocal_training
      vocal_training_text
    end
  end
end

class InstrumentalEvaluation < Evaluation
end

class VocalEvaluation < Evaluation
end



