# -*- coding: utf-8 -*-
####################### Electives ############################
## Electives come and go year to year.  They are gated by a flag "active"
## true by default. This method reconstructs all electives that ever happened, and sets
## them all to active. Note that references to instruments are hard-coded by ID

def link_elective_to_instruments(elective, list_of_instrument_ids)
  list_of_instrument_ids.each{|iid| elective.instruments << Instrument.find(iid)}
  elective.save!
end

def create_electives

  Elective.all.each{|e| e.destroy!}

  #####  2017
  e = Elective.create(
                      :id => 1,
                      :name => "Free Time",
                      :instructor => "You!",
                      :description => "You're not being lazy; you deserve it! And don't let anybody tell you otherwise. If they do, punch them!  Then take a nap."
                      )

  ##### 2017
  e = Elective.create(
                      :id => 2,
                      :name => "Composition",
                      :instructor => "Roupen Shakarian",
                      :description => "The composition class is a workshop for those who are already working on a piece or would like to have input on their completed work(s). Prior experience and knowledge of intermediate theory is required."
                      )

  ##### 2017
  e = Elective.create(
                      :id => 3,
                      :name => "Music Theory for the Fun of It",
                      :instructor => "Thane Lewis",
                      :description => "Join us for a four-day journey into the language of music. You will do some simple and fun ear training and dictation. You will experience enlightenment as you clarifiy musical terms and review simple notation, keys and key signatures and their relationships.  A special guest artist of the musical occult will join us to plumb the human psychology and mystery of the progression and you will investigate some friendly web-based musical resources to take your study of theory and ear-training with you when you return to the mundane world. An experience not to be missed."
                      )

  ##### 2017
  e = Elective.create(
                      :id => 4,
                      :name => "Beginning Voice Class",
                      :instructor => "Gabriel Gargari",
                      :description => "This elective is geared toward those who are new to singing and will cover the basics of vocal production and singing. Participants will each learn one song for possible solo performance. Open to instrumentalists and vocalists; previous music fundamentals or sight-reading skills study advised."
                      )
  link_elective_to_instruments(e, [1,2,3,4,5])

  #####  Reactivated 2017
  e = Elective.create(
                      :id => 6,
                      :name => "Baroque Orchestra for Strings",
                      :instructor => "Sandi Schwarz",
                      :description => "Explore repertoire and techniques with a master. Will perform at Saturday Tea."
                      )
  link_elective_to_instruments(e, [6,7,8,9])

  ##### 2017
  e = Elective.create(
                      :id => 7,
                      :name => "Flute Choir",
                      :instructor => "Faculty",
                      :description => "A choir!  Of Flutes!!  Lots of flutes!!!  The more flutes the better!!!!  Maybe if we all play up an octave we can break a commemorative wine glass!!!!"
                      )
  link_elective_to_instruments(e, [])

  ############ Listen up, because this is a hack!!!  
  #  Having a dropdown for flute choir was deemed confusing, so the easiest fix is
  #  to remove the requirement here so it doesn't show up on the elective page then 
  #  look specifically for this elective (by name) when figuring out which evals 
  #  are required.  EnsemblePrimary.need_eval_for has the code that looks for "Flute Choir" 
  #  by name.  So if you get rid of Flute Choir, or change the instrument ID for flute or piccolo, 
  #  watch out!!!

  #link_elective_to_instruments(e, [11])

  ##### 2017
  e = Elective.create(
                      :id => 8,
                      :name => "Percussion Ensemble",
                      :instructor => "Percussion Faculty",
                      :description => "An ensemble.  Of percussion.  Loud! Not annoying loud, just loud!  As long as you're not living upstairs."
                      )
  link_elective_to_instruments(e, [28,31])

  #####  2017
  e = Elective.create(
                      :id => 9,
                      :name => "Drum Circle",
                      :instructor => "Patrick Roulet",
                      :description => "You do not have to be a master drummer to succeed in this class. After learning the basic technique for hand drumming we will learn African and Latin drumming patterns. Through these patterns we practice our ensemble skills of listening, feeling the internal pulse and fitting our rhythm into the pattern. Past students have said that transferring what they learn in this class to their other instruments helps them in rehearsal and performance settings. "
                      )
  link_elective_to_instruments(e, [])

  ##### 2017
  e = Elective.create(
                      :id => 10,
                      :name => "Afternoon Elective Orchestra",
                      :instructor => "Roger Nelson",
                      :description => "An afternoon ensemble for strings and classical brass and winds. Repertoire drawn from all eras. Lots of sight reading; low key performance. Very fun!"
                      )
  link_elective_to_instruments(e, [6,7,8,9,11,12,14,15,16,22,23,24,27,28,31,32])

  ##### 2017
  e = Elective.create(
                      :id => 11,
                      :name => "Brass Ensemble",
                      :instructor => "William Berry",
                      :description => "Open to all brass. Uses standard, modern instruments. So if you have non-standard non-modern instruments, leave them in your dorm room!"
                      )
  link_elective_to_instruments(e, [22,23,24,26,27])

  #####  2017
  e = Elective.create(
                      :id => 12,
                      :name => "Jazz Big Band",
                      :instructor => "Jim Sisko",
                      :description => "An ideal group for all who enjoy performing large ensemble jazz.  The group features traditional big band instrumentation: saxophones, trumpets, trombones and rhythm section players -- piano, bass and drums. Repertoire is drawn from a mix of unique arrangements of  jazz standards and originals. The band performs at Skit Night."
                      )
  link_elective_to_instruments(e, [17,18,19,20,21,22,24,28,34,9])

  ##### 2017
  e = Elective.create(
                      :id => 13,
                      :name => "Jazz Improvisation",
                      :instructor => "Jim Sisko",
                      :description => "Open to instrumentalists and vocalists, this class will cover the basics of improvising: chord progressions, what scales to use with what chords, articulation styles, and how to develop a melody."
                      )
  link_elective_to_instruments(e, [])

  ##### 2017
  e = Elective.create(
                      :id => 14,
                      :name => "Saxophone Ensemble", 
                      :instructor => "Patrick Sheng",
                      :description => "An ensemble.  Of saxophones. You will all think you are the coolest musicians at MMR!  And who\'s to say you are wrong about that?"
                      )
  link_elective_to_instruments(e, [17,18,19,20,21])


  ##### 2017
  e = Elective.create(
                      :id => 22,
                      :name => "Musicianship for Singers",
                      :instructor => "Loren Ponten",
                      :description => "Are you overwhelmed by what you see in a choral or vocal score? Do you self-select out of MMR electives because you think your sight-reading or music fundamentals skills are subpar? Do you always learn music by hearing it first? This elective is for you! Through this introductory level elective using the tried and tested Kodaly Method, participants will develop critical musical thinking and reading skills, and cultivate inner hearing through direct experience with the fundamentals of music."
                      )
  link_elective_to_instruments(e, [1,2,3,4,5])

  ##### 2017
  e = Elective.create(
                      :id => 26,
                      :name => "And the Beat Goes On... ",
                      :instructor => "Michael Burch-Pesses",
                      :description => "Before Melody and Harmony came Rhythm. Immerse yourself in the  fundamental tool of the singer or instrumentalist."
                      )
  link_elective_to_instruments(e, [])

  ##### 2017
  e = Elective.create(
                      :id => 27,
                      :name => "Clarinet Choir",
                      :instructor => "Faculty",
                      :description => "A Choir!  Of Clarinets!! What could be more heavenly than that? I mean let's face it, clarinet is the Rodney Dangerfield of woodwinds.  It gets no respect.  But it should -- it should get lots of respect!! And if you join the Clarinet Choir, you can help prove everybody wrong and stop all those nasty and false things they are saying about clarinets.  So in some sense it is your moral duty to sign up for Clarinet Choir.  Whether or not you are a clarinet player."
                      )
  link_elective_to_instruments(e, [15,16])

  ##### 2017
  e = Elective.create(
                      :id => 29,
                      :name => "Great American Songbook (All Voices)", 
                      :instructor => "Margaret Green",
                      :description => "Rekindle your love of songs from the Great American Songbook or dive into a genre of music that you haven't yet experienced. We will experience the music of George and Ira Gershwin, Cole Porter, Rodgers and Hart, Irving Berlin, Jerome Kern, and many other prolific composers.  This elective will involve listening, lively discussion, singing, and performance.  While we will explore these great composers from this time in history, we will also look at some of the distinctive voices that made the music come to life. Previous singing experience and good sight-reading skills recommended."
                      )
  link_elective_to_instruments(e, [1,2,3,4,5])

  #####  2017
  e = Elective.create(
                      :id => 31, 
                      :name => "I Hate to Read Music, But I Love to Sing!",
                      :instructor => "Lisa Cardwell Ponten", 
                      :description => "Are you intimidated by sight-reading? Here is a class for you! We'll work on various strategies for looking at music for the first time and making sense out it. Even if you feel you are a beginner, this can help you get to the next level. This will be a 100% supportive and fun learning environment! Instrumentalists are welcome; please know participants will be using their voices a great deal."
                      )
  link_elective_to_instruments(e, [1,2,3,4,5])

  #####  2017
  e = Elective.create(
                      :id => 32, 
                      :name => "Gentle Yoga",
                      :instructor => "Lydia Van Dreel", 
                      :description => "Gentle Yoga is a slow, relaxing yoga asana (posture) practice, suitable for all body types and all levels of experience. Focus is on connecting the breath with movement and down-regulating the body’s nervous system. Like other styles of yoga, gentle yoga can relieve stress, increases flexibility, calm the mind, and strengthen the body. Gentle yoga, in particular, can be relaxing and help enhance the range of motion. Students interested in this course should bring comfortable clothing for stretching, and a yoga mat."
                      )
  link_elective_to_instruments(e, [])

   #####  New 2017, needs instrument linking
  e = Elective.create(
                      :id => 33, 
                      :name => "Fingerboard Geography for Violinists",
                      :instructor => "Deedee Cook",
                      :description => "An adventurous class exploring the uncharted territories of the violin fingerboard.  The curriculum will include building a healthy and efficient left-hand technique through tetrachords (4-note finger patterns), examining the intervallic relationship between fingers, exploring new positions, developing courageous shifts, and tender loving care of the pinky. A fun class for violinists at all levels."
                      )
  link_elective_to_instruments(e, [6])

  #### 2017
  e = Elective.create(
                      :id => 34, 
                      :name => "Introduction to the Alexander Technique",
                      :instructor => "Adam Burdick",
                      :description => "The Alexander Technique offers principles that help us to understand our body.s structure and workings and uncover how our habits of movement and misconceptions of form can work against our best use of our selves. Using these principles, we can clarify and refine our movements in any activity, from the seemingly simple like getting out of a chair, to the undoubtedly complex, like playing a musical instrument. Join Adam as he shares some favorite insights to help you explore more nuanced ways to think about your body and your movement. Open to all; no experience necessary."
                      )
  link_elective_to_instruments(e, [])

  #### 2017
  e = Elective.create(
                      :id => 35,
                      :name => "Womens\' \"Anything But Classical\" Vocal Ensemble",
                      :instructor => "Adam Burdick",
                      :description => "There is plenty of popular music out there that is challenging enough to satisfy a discriminating singer with catchy tunes, rich harmonies, and interesting arrangements that are a lot of fun to sing. We will explore music by vocally \"tight\" trios of the 40s, 50s, 60s, and 90s, solo artists like Karen Carpenter and Enya, world- and folk-influenced groups like Sweet Honey In the Rock, and a new generation of creative a cappella women\'s groups like Moira Smiley and VOCO. Previous singing experience and good sight-reading skills recommended"
                      )
  link_elective_to_instruments(e, [1,2])

### New for 2017 needs linking
  e = Elective.create(
                    :id => 36,
                    :name => "Madrigal Madness",
                    :instructor => "Katie Weld",
                    :description => "This elective is perfect for instrumentalists and vocalists who want to explore English and Italian madrigals and who want to get their fill of &lsquo;fa la la la las%rsquo. Instrumentalists: Consider playing a vocal line on your instrument or singing; vocalists: consider singing or playing your vocal line on a secondary instrument. Good sight-reading skills recommended."
)
  link_elective_to_instruments(e, [1,2])

### New for 2017 needs linking
  e = Elective.create(
                    :id => 37,
                    :name => "They're Not Dead Yet: Choral Music of Living Composers",
                    :instructor => "Scott Kovacs",
                    :description => "Open to all voice types, this elective will explore choral music by living composers, an area of passion and expertise for Scott. This elective will involve critical listening, singing, and performance. Previous singing experience and good sight-reading skills recommended."
                    )
  link_elective_to_instruments(e, [1,2,3,4,5])
end

#######################################################################################
## CURRENTLY DEACTIVATED

#   #####  Deactivated
#   e = Elective.create(
#                       :id => 5,
#                       :name => "Bowing Techniques",
#                       :instructor => "Cecilia Archuleta",
#                       :description => "A class emphasizing bow control. How to sustain a beautiful sound, on those slow movements.  Learn to play comfortably at the frog and tip of the bow.  Produce the sound you want to hear!"
#                       )
#   link_elective_to_instruments(e, [6,7,8,9])

#   #####  Deactivated

#   e = Elective.create(
#                       :id => 15,
#                       :name => "Fiddling",
#                       :instructor => "Carol Ann Wheeler",
#                       :description => "Delve into fiddle styles and techniques with a master fiddler."
#                       )
#   link_elective_to_instruments(e, [6,7])

#   #####  Deactivated
#   e = Elective.create(
#                       :id => 16,
#                       :name => "Solo Bach For The String Player",
#                       :instructor => "Meg Brennand",
#                       :description => "Now offered for all strings!  Explore the mystical world of solo Bach. Get the insider\'s perspective on tempi, articulation, and style that Bach would have expected any accomplished 18th century string player to know. Master class format (performance optional). Prepare a movement to perform from the Bach cello suites, the violin sonatas or partitas; or simply come and observe."
#                       )
#   link_elective_to_instruments(e, [6,7,8,9])

#   ##### Deactivated
#   e = Elective.create(
#                       :id => 17,
#                       :name => "Eurythmics",
#                       :instructor => "Deede Cook",
#                       :description => "Develop your musical understanding with a dip into the system of rhythmical physical movements created by Emile Jaques-Dalcroze."
#                       )
#   link_elective_to_instruments(e, [])

 
#   #####  Deactivated
#   e = Elective.create(
#                       :id => 18,
#                       :name => "Building A Vocal Community",
#                       :instructor => "Margaret Green",
#                       :description => "Participants in this elective will create a community through our singing together. All music will be taught in call and response style (up to four parts) and will include music from African, spiritual, and gospel vocal traditions. Participants may also experiment with playing djembe and other percussion that enhances the singing. No prior singing experience is necessary."
#                       )
#   link_elective_to_instruments(e, [])

#  #####  Deactivated
#   e = Elective.create(
#                       :id => 19,
#                       :name => "Opera Choruses for Women",
#                       :instructor => "Adam Burdick",
#                       :description => "Explore choruses for women's voices from great English and Italian operas in a supportive, creative learning environment. Learn the stories behind the choruses and their place in each production. Good sight-reading skills required."
#                       )
#   link_elective_to_instruments(e, [1,2])

#   #####  Deactivated
#   e = Elective.create(
#                       :id => 20,
#                       :name => "Just for Mens\' Voices",
#                       :instructor => "Jason Anderson",
#                       :description => "Breath, imagination, text/meaning, and body/mind will help guide participants in this vocal elective as we explore music from chant to music of the 21st century. Prior singing experience and a working knowledge of music fundamentals is recommended."
#                       )
#   link_elective_to_instruments(e, [3,4,5])

#   #####  Deactivated
#   e = Elective.create(
#                       :id => 21,
#                       :name => "Just for Womens\' Voices",
#                       :instructor => "Lisa Cardwell Ponten",
#                       :description => "Breath, imagination, text/meaning, and body/mind will help guide participants in this vocal elective as we explore music from chant to music of the 21st century. Prior singing experience and a working knowledge of music fundamentals is recommended."
#                       )
#   link_elective_to_instruments(e, [1,2])

#   #####  Deactivated
#   e = Elective.create(
#                       :id => 23,
#                       :name => "Solfege is Fun!",
#                       :instructor => "Katie Weld",
#                       :description => "Connect solfege to part song singing, mix in some music theory, some more singing, a bit more theory, and much more singing. In this elective you will learn to turn your DO RE MIs into music and perform some good ol' madrigals and/or part songs along the way."
#                       )
#   link_elective_to_instruments(e, [])

#   #####  Deactivated
#   e = Elective.create(
#                       :id => 24,
#                       :name => "Opera Workshop",
#                       :instructor => "Charles Robert Stephens",
#                       :description => "Participants will explore short scenes from selected operas, hone stage presence skills, and learn to work both as a soloist and ensemble cast member. Ability to sing in German, Italian, and/or French required; previous stage experience recommended."
#                       )
#   link_elective_to_instruments(e, [1,2,3,4,5])

#   #####
#   e = Elective.create(
#                       :id => 25,
#                       :name => "Rock Orchestra for Strings",
#                       :instructor => "Adam Burdick",
#                       :description => "From the earliest days of rock and roll, creative producers explored ways to add a touch of class to rock and pop arrangements, branching beyond the basic lineup with the additions of strings and other orchestral instruments. Come explore a variety of styles, from Nashville to New York and Los Angeles to London. Note: area coordinators will work together to assign participants to this elective as instrumentation and space allow."
#                       )
#   link_elective_to_instruments(e, [6,7,8,9])

#   #####
#   e = Elective.create(
#                       :id => 28,
#                       :name => "Bach and (Adult) Beverages", 
#                       :instructor => "Katie Weld",
#                       :description => "Back by popular demand.songs for both sides of your brain! Explore drinking songs in English and other languages (when your tongue is appropriately unfettered at Fermata Bar) and then dive head first into Johann Sebastian Bach's demented and glorious music. What's a little fugue among friends? Prior singing experience and a working knowledge of music fundamentals is helpful."
#                       )
#   link_elective_to_instruments(e, [1,2,3,4,5])

#   #####
#     e = Elective.create(
#                         :id => 30,
#                         :name => "Great American Songbook: Men's Voices", 
#                         :instructor => "Jason Anderson",
#                         :description => "Rekindle your love of songs from the Great American Songbook or dive into a genre of music that you haven't yet experienced. We will experience the music of George and Ira Gershwin, Cole Porter, Rodgers and Hart, Irving Berlin, Jerome Kern, and many other prolific composers.  This elective will involve listening, lively discussion, singing, and performance.  While we will explore these great composers from this time in history, we will also look at some of the distinctive voices that made the music come to life. Previous singing experience and good sight-reading skills recommended."
#                         )
#   link_elective_to_instruments(e, [3,4,5])

# #######################################################################################
# ## This is year-specific controlling of electives.  Should be moved to a config file! #

# def deactivate_electives
#   [5, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 28, 30].each{|n| e = Elective.find(n); e.active = false; e.save!}
# end
