class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :ensemble_primary_id
      t.integer :instrument_id
      t.string :type

      t.integer :large_ensemble_part     # first second or third, 0,1,2, 10 is reserved for piccolo, 100 - 103 reserved for soprano...sax
      t.integer :chamber_ensemble_part   # 

      # Other instruments grouped by primary
      t.boolean :other_instrument_oboe
      t.boolean :other_instrument_english_horn
      t.boolean :other_instrument_oboe_other

      t.boolean :other_instrument_trombone
      t.boolean :other_instrument_bass_trombone


      t.boolean :other_instrument_bb_trumpet
      t.boolean :other_instrument_c_trumpet
      t.boolean :other_instrument_piccolo_trumpet

      t.boolean :other_instrument_saxophone_soprano
      t.boolean :other_instrument_saxophone_soprano
      t.boolean :other_instrument_saxophone_soprano
      t.boolean :other_instrument_saxophone_soprano

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

      t.boolean :percussion_snare
      t.boolean :percussion_timpani
      t.boolean :percussion_mallets
      t.boolean :percussion_small_instruments
      t.boolean :percussion_drum_set

      t.text :groups
      t.boolean :require_audition
      t.boolean :studying_privately
      t.string :studying_privately_how_long
      t.integer :chamber_music_how_often   #should be 0 through 2
      t.integer :practicing_how_much       #should be 0 through 2

      # Piano
      t.string :composers

      # Jazz
      t.boolean :jazz_want_ensemble
      t.boolean :jazz_small_ensemble
      t.boolean :jazz_big_band

      # Vocal
      t.integer :vocal_low_high  # For soprano and alto, 0 is low, 1 is high
      t.string :vocal_overall_ability  # 0 to 3
      t.integer :vocal_how_learn # 0 reading music, 1, by ear
      t.string :vocal_most_difficult_piece
      t.boolean :vocal_music_theory
      t.string :vocal_music_theory_year
      t.boolean :vocal_voice_class
      t.string :vocal_voice_class_year
      t.boolean :vocal_voice_lessons
      t.string :vocal_voice_lessons_year
      t.string :vocal_small_ensemble_skills # 0,1,2

      # String
      t.boolean :third_position
      t.boolean :fourth_position
      t.boolean :fifth_position
      t.boolean :sixth_position
      t.boolean :seventh_position
      t.boolean :thumb_position
      

      # Overall assessment
      t.integer :overall_rating_large_ensemble  # should be 0 through 4
      t.integer :overall_rating_chamber
      t.integer :overall_rating_sightreading  # 0 to 3, poor, average, good, excellent

      t.timestamps
    end
  end
end
