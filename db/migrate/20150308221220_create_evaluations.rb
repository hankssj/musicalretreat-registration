class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :ensemble_primary_id
      t.integer :instrument_id
      t.string :type

      # Same as large_ensemble_part in EnsemblePrimary
      # 0,1,2 for first second or third. 10 is reserved for piccolo, 
      # 100 - 103 reserved for soprano,alto,tenor,baritone sax
      t.integer :chamber_ensemble_part

      # Transpositions for trumpet and horn -- horn E, Eb, D;  trumpet -- C, B, Eb
      t.boolean :transposition_0
      t.boolean :transposition_1
      t.boolean :transposition_2

      ##############
      # Other instruments brought to camp -- grouped by primary instrument

      t.boolean :other_instrument_oboe
      t.boolean :other_instrument_english_horn
      t.boolean :other_instrument_oboe_other   # This is joke placeholder for 
                                               # many silly oboe-like instruments

      t.boolean :other_instrument_trombone
      t.boolean :other_instrument_bass_trombone

      t.boolean :other_instrument_bb_trumpet
      t.boolean :other_instrument_c_trumpet
      t.boolean :other_instrument_piccolo_trumpet

      t.boolean :other_instrument_saxophone_soprano
      t.boolean :other_instrument_saxophone_alto
      t.boolean :other_instrument_saxophone_tenor
      t.boolean :other_instrument_saxophone_baritone

      t.boolean :other_instrument_bb_clarinet
      t.boolean :other_instrument_a_clarinet
      t.boolean :other_instrument_eb_clarinet
      t.boolean :other_instrument_alto_clarinet
      t.boolean :other_instrument_bass_clarinet

      t.boolean :other_instrument_c_flute
      t.boolean :other_instrument_piccolo
      t.boolean :other_instrument_alto_flute
      t.boolean :other_instrument_bass_flute

      t.boolean :other_instrument_trombone
      t.boolean :other_instrument_bass_trombone

      t.boolean :other_instrument_drum_set
      t.boolean :other_instrument_mallets

      t.text :other_instruments_you_tell_us

      #####################

      # In percussion evaluation, what percussion do you play?
      t.boolean :percussion_snare
      t.boolean :percussion_timpani
      t.boolean :percussion_mallets
      t.boolean :percussion_small_instruments
      t.boolean :percussion_drum_set

      # Groups partial
      t.text :groups
      t.boolean :require_audition
      t.boolean :studying_privately
      t.string  :studying_privately_how_long
      t.integer :chamber_music_how_often   #should be 0 through 2
      t.integer :practicing_how_much       #should be 0 through 2

      # Piano only
      t.string :composers

      # Jazz instruments only
      t.boolean :jazz_want_ensemble
      t.boolean :jazz_small_ensemble
      t.boolean :jazz_big_band

      # Vocal evaluation only
      t.integer :vocal_low_high  # For soprano and alto, 0 is low, 1 is high
      t.string  :vocal_overall_ability  # 0 to 3
      t.integer :vocal_how_learn # 0 reading music, 1, by ear
      t.string  :vocal_most_difficult_piece
      t.boolean :vocal_music_theory
      t.string  :vocal_music_theory_year
      t.boolean :vocal_voice_class
      t.string  :vocal_voice_class_year
      t.boolean :vocal_voice_lessons
      t.string  :vocal_voice_lessons_year
      t.string  :vocal_small_ensemble_skills # 0,1,2

      # String evaluation only
      t.boolean :third_position
      t.boolean :fourth_position
      t.boolean :fifth_position
      t.boolean :sixth_position
      t.boolean :seventh_position
      t.boolean :thumb_position
      

      # Overall assessment partial
      t.integer :overall_rating_large_ensemble  # 0 to 4
      t.integer :overall_rating_chamber         # 0 to 4
      t.integer :overall_rating_sightreading    # 0 to 3, poor, average, good, excellent

      t.timestamps
    end
  end
end
