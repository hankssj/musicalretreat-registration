#########################################
##  NB -- there is a dependency between the code and the actual headers in the data file, 
##  public/contacts/MMR_Contacts.tab
##  This code requires fields with names contact_id, lastname, firstname, and email
##  That probably will not be the case with the file drops, so you need to edit the file directly.
#########################################

class FileMakerContact
  @@headers = nil
  @@records = nil

  def self.manuals
    {
      "athomp@uwm.edu" => 817,
      "cbmoss.1@gmail.com" => 595,
      "jimwhitehead@comcast.net" => 2280,
      "fkhoeveler@gmail.com" => 2623,
      "bluesgators@verizon.net" => 2345,
      "lesleypetty@gmail.com" => 442
    }
  end

  def self.records
    @@records
  end

  def initialize(record)
    @record = record
  end

  def self.load
    File.open("#{RAILS_ROOT}/public/contacts/MMR_Contacts.tab") do |f|
      lines = f.gets.split(/[\n\r]/)
      @@headers = lines[0].split(/\t/).map{|x|x.intern}
      lines.shift
      @@records = lines.map{|l| FileMakerContact.new(l.split(/\t/))}
    end
  end

  def method_missing(arg)
    ind = @@headers.index(arg)
    ind ? @record[ind] : super.method_missing(arg)
  end

  def matches(user)
    return true if email && user.email && user.email.lmatch(email)
    r = user.most_recent_registration
    return false unless r
    return true if r.first_name.lmatch(firstname) && r.last_name.lmatch(lastname)
    return false
  end

  def self.findMatches(user)
    @@records.select{|r| r.matches(user)}
  end

  def self.findMatch(user)
    m = findMatches(user)
    return nil if m.size == 0
    return m.first
  end

  def self.findContactID(user)
    return manuals[user.email] if manuals[user.email]
    match = findMatch(user)
    return match.contact_id if match
    return nil
  end

  def self.newContactID
    min_contact_id = 5000
    1 + [User.find(:all).map{|u|u.contact_id}.compact.sort.reverse.first, min_contact_id].max
  end
  
  def self.setContactID(registration)
    load unless @@records
    user = registration.user
    if user.contact_id
      Event.log("Contact: User #{user.id} #{user.email} already has contact ID, sticking with #{user.contact_id}")
    else
      cid = findContactID(user)
      if cid
        Event.log("Contact: Found match for user #{user.id} #{user.email}:  setting to #{cid}")
      else
        cid = newContactID
        Event.log("Contact: Created new contact ID for user #{user.id} #{user.email}: setting to #{cid}")
      end
      user.contact_id = cid
      user.save!
    end
  end

  def self.losers
    #  uu = Registration.find(:all).map{|r| r.user}.uniq
    load unless @@records
    uu = User.find(:all).reject{|u|u.bounced_at}
    uu.each do |u| 
      unless findContactID(u)
        r = u.most_recent_registration
        puts "#{u.id} #{u.email} #{r.first_name} #{r.last_name} #{r.instrument_name} #{r.year}" if r
#        print "#{u.id} #{u.email}"
#        puts "#{r.first_name} #{r.last_name} #{r.instrument_name} #{r.year}" if r
#        puts " (no registration)" unless r
      end
    end
    ""
  end

end

class String
  def lmatch(s)
    self.strip.downcase == s.strip.downcase
  end
end


