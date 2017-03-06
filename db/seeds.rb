#######  Run through rake db:seed to create some accounts, instruments, and electives
#######  in cases where electives change, best to do it manually:  change the electives then clear the table
#######  and create them again.  If this whole file is run, it will create reference account, all instruments,
#######  and all electives.
#######  
#######  There are additional methods to create test users and accounts, and to selectively de-activate 
#######  electives, which need to be run manually

################# Reference User ############################

def create_reference_account
  User.create(:email => "midsummer@musicalretreat.org", :password => "walla2", :admin => true)
end

################# Instruments ############################

def create_instruments
  Instrument.all.each{|i| i.destroy!}

  Instrument.create(:id => 1,  :display_name => "Voice-Soprano",      :large_ensemble => "chorus", :instrument_type => "vocal")
  Instrument.create(:id => 2,  :display_name => "Voice-Alto",         :large_ensemble => "chorus", :instrument_type => "vocal")
  Instrument.create(:id => 3,  :display_name => "Voice-Tenor",        :large_ensemble => "chorus", :instrument_type => "vocal")
  Instrument.create(:id => 4,  :display_name => "Voice-Baritone",     :large_ensemble => "chorus", :instrument_type => "vocal")
  Instrument.create(:id => 5,  :display_name => "Voice-Bass",         :large_ensemble => "chorus", :instrument_type => "vocal")
  Instrument.create(:id => 6,  :display_name => "Violin",             :large_ensemble => "festival_or_string_orchestra", :instrument_type => "string")
  Instrument.create(:id => 7,  :display_name => "Viola",              :large_ensemble => "festival_or_string_orchestra", :instrument_type => "string")
  Instrument.create(:id => 8,  :display_name => "Cello",              :large_ensemble => "festival_or_string_orchestra", :instrument_type => "string")
  Instrument.create(:id => 9,  :display_name => "Double Bass",        :large_ensemble => "festival_or_string_orchestra", :instrument_type => "string")
#  Instrument.create(:id => 10, :display_name => "Piccolo",            :large_ensemble => "band_or_orchestra", :instrument_type => "woodwind")
  Instrument.create(:id => 11, :display_name => "Flute",              :large_ensemble => "band_or_orchestra", :instrument_type => "woodwind")
  Instrument.create(:id => 12, :display_name => "Oboe",               :large_ensemble => "band_or_orchestra", :instrument_type => "woodwind")
  Instrument.create(:id => 14, :display_name => "Bassoon",            :large_ensemble => "band_or_orchestra", :instrument_type => "woodwind")
  Instrument.create(:id => 15, :display_name => "Clarinet",           :large_ensemble => "band_or_orchestra", :instrument_type => "woodwind")
#  Instrument.create(:id => 37, :display_name => "Clarinet-Alto",      :large_ensemble => "band_or_orchestra", :instrument_type => "woodwind")
  Instrument.create(:id => 16, :display_name => "Clarinet-Bass",      :large_ensemble => "band_or_orchestra", :instrument_type => "woodwind")
  Instrument.create(:id => 17, :display_name => "Saxophone",          :large_ensemble => "band", :instrument_type => "woodwind")
  Instrument.create(:id => 18, :display_name => "Saxophone-Soprano",  :large_ensemble => "band", :instrument_type => "woodwind")
  Instrument.create(:id => 19, :display_name => "Saxophone-Alto",     :large_ensemble => "band", :instrument_type => "woodwind")
  Instrument.create(:id => 20, :display_name => "Saxophone-Tenor",    :large_ensemble => "band", :instrument_type => "woodwind")
  Instrument.create(:id => 21, :display_name => "Saxophone-Baritone", :large_ensemble => "band", :instrument_type => "woodwind")
  Instrument.create(:id => 22, :display_name => "Trumpet",            :large_ensemble => "band_or_orchestra", :instrument_type => "brass")
  Instrument.create(:id => 23, :display_name => "Horn",               :large_ensemble => "band_or_orchestra", :instrument_type => "brass")
  Instrument.create(:id => 24, :display_name => "Trombone",           :large_ensemble => "band_or_orchestra", :instrument_type => "brass")
#  Instrument.create(:id => 25, :display_name => "Trombone-Bass",      :large_ensemble => "band_or_orchestra", :instrument_type => "brass")
  Instrument.create(:id => 26, :display_name => "Euphonium",          :large_ensemble => "band", :instrument_type => "brass")
  Instrument.create(:id => 27, :display_name => "Tuba",               :large_ensemble => "band_or_orchestra", :instrument_type => "brass")
  Instrument.create(:id => 28, :display_name => "Percussion",         :large_ensemble => "band_or_orchestra", :instrument_type => "percussion")
  Instrument.create(:id => 31, :display_name => "Timpani",            :large_ensemble => "band_or_orchestra", :instrument_type => "percussion")
  Instrument.create(:id => 32, :display_name => "Harp",               :large_ensemble => "festival_or_string_orchestra", :instrument_type => "string")
  Instrument.create(:id => 34, :display_name => "Piano",              :large_ensemble => "none", :instrument_type => "string")
end

##################### Test users and registrations ###########################
##  This does not get run automatically.  Should be run only in development.

def create_test_users
  Instrument.all.each do |instrument|
    u = User.new(email: "#{instrument.display_name.gsub(' ', '-').downcase}@mmr.org", test: true)
    u.password = "mmr"
    u.save!
  end
end

def create_test_registrations
  Instrument.all.each do |instrument|
    email = "#{instrument.display_name.gsub(' ', '-').downcase}@mmr.org"
    u = User.find_by_email(email)
    Registration.create!(year: Year.this_year, user_id: u.id, first_name: "Test", 
                         last_name: instrument.display_name, street1: "Any", city: "Any", state: "WA", zip: "98101",
                         home_phone: "2061111111", work_phone: "2061111111", cell_phone: "2061111111",
                         instrument_id: instrument.id)
  end
end


############# Assumes all tables and nothing in them.  Affects only Instrument, Elective and their links.
############# Adds the reference account, but all other accounts are test accounts, and all registrations are 
############# attached to test accounts.

#create_reference_user
#create_instruments
#create_electives

##############################################################################################
##   Board, staff, faculty, and major volunteers

def staff
  [
   "jessicacroysdale@yahoo.com", 
   "margynewton@comcast.net", 
   "brantallen@earthlink.net", 
   "ksunmark@yahoo.com", 
   "gorakr@comcast.net", 
   "lhpilcher@frontier.com", 
   "mmr@brantallen.com", 
   "manbeardo@gmail.com", 
   "jcermak53@gmail.com"
  ]
end

def reset_staff
  User.all.each{|u| u.staff = false; u.save!}
  staff.each do |e| 
    u = User.find_by_email(e); 
    raise "no record for #{e}" unless u
    u.staff = true
    u.save!
  end
end

def faculty
  []
end

def reset_faculty
  User.all.each{|u| u.faculty = false; u.save!}
  faculty.each do |e| 
    u = User.find_by_email(e); 
    raise "no record for #{e}" unless u
    u.faculty = true; 
    u.save!
  end
end

def major_volunteer
  []
end

def reset_major_volunteer
  User.all.each{|u| u.major_volunteer = false; u.save!}
  major_volunteer.each do |e| 
    u = User.find_by_email(e); 
    raise "no record for #{e}" unless u
    u.major_volunteer = true; u.save!
  end
end

def board
  ["June.hiratsuka@comcast.net",
   "suecdc@msn.com",
   "rbhudson@comcast.net",
   "Ivoryharp1@gmail.com",
   "hutcheson@seanet.com",
   "genniewinkler@comcast.net",
   "rkremers@earthlink.net",
   "szell41534@aol.com",
   "donamac@mac.com",
   "rumeimistry@yahoo.com",
   "rm.thompson@frontier.com"
]
end

def reset_board
  User.all.each{|u| u.board = false; u.save!}
  board.each do |e| 
    u = User.find_by_email(e)
    raise "no record for #{e}" unless u
    u.board = true; u.save!
  end
end

###########################################
#  Mailing list is different --
#  Read from a file in config
#  Do not start from scratch because otherwise unsubscribe and bounces will be lost
#    -- real deletes will have to be manual

def new_random_url_code
  codes = MassEmail.all.map{|m|m.url_code}.map{|u|u.to_i}
  new_code = Random.rand(9999999)
  while codes.include?(new_code)
    new_code = Random.rand(9999999)
  end
  new_code.to_s.rjust(7, '0')
end

##  At the end, guarantee that all emails in the file config/mailing_list.txt are on the list,
##  that all User emails are on the list.  But do not delete anything on the list, and do not
##  overwrite anything on the list.   (You can effectively do that by setting the unsubscribe bit.)

def refresh_mailing_list
  emails = MassEmail.all.map{|m|m.email_address}
  File.open(File.join(Rails.root, 'config', 'mailing_list.txt')).each_line do |e|
    e = e.chomp
    unless emails.include?(e)
      url_code = new_random_url_code
      m = MassEmail.new(email_address: e, url_code: url_code)
      m.save!
    end
  end

  emails = MassEmail.all.map{|m|m.email_address}
  User.all.map{|u| u.email}.each do |e| 
    unless emails.include?(e)
      url_code = new_random_url_code
      m = MassEmail.new(email_address: e, url_code: url_code)
      m.save!
    end
  end
end
