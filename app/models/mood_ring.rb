class MoodRing

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat( vars )
    super
  end

  attr_accessor(:mood, :optimistic, :comment, :confidence)

  def self.attributes
    @attributes
  end

  def initialize(attributes={})
    attributes && attributes.each do |name, value|
      send("#{name}=", value) if respond_to? name.to_sym 
    end
    
    mood ||= "happy"
    optimistic ||= "0"
    comment ||= ""
    confidence ||= 0
  end

  def trending
    return "euphoric" if mood == "happy" && optimistic == "1"
    return "sinking" if mood == "happy" && optimistic != "1"
    return "improving" if mood == "sad" && optimistic == "1"
    return :depressed
  end

  def persisted?
    false
  end

  def self.inspect
    "#<#{ self.to_s} #{ self.attributes.collect{ |e| ":#{ e }" }.join(', ') }>"
  end

end
