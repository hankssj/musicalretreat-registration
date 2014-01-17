class MoodController < ApplicationController

  def new
    @mood_ring = session[:mood_ring] = MoodRing.new(:mood => "happy", :optimistic => "0")
  end

  def create
    @mood_ring = session[:mood_ring] = MoodRing.new(params[:mood_ring])
  end
  
  # onclick on the check box.  Oddly, it looks like when the box is checked, it sense params["mood_ring"]["optimistic"] == 1
  # but when the box is unchecked, it sense no params.  

  def update_optimistic
    new_optimistic = params[:mood_ring] && params[:mood_ring][:optimistic] ? params[:mood_ring][:optimistic] : "0"
    session[:mood_ring].optimistic = new_optimistic
    @mood_ring = session[:mood_ring]
    respond_to do |format|
      format.js {render :update_mood_ring}
    end
  end

  def update_mood
    new_mood = params[:mood_ring] && params[:mood_ring][:mood] ? params[:mood_ring][:mood] : "unknown"
    session[:mood_ring].mood = new_mood
    @mood_ring = session[:mood_ring]
    respond_to do |format|
      format.js {render :update_mood_ring}
    end
  end

  def update_comment
    new_comment = params[:mood_ring] && params[:mood_ring][:comment] ? params[:mood_ring][:comment] : "unknown"
    session[:mood_ring].comment = new_comment
    @mood_ring = session[:mood_ring]
    respond_to do |format|
      format.js {render :update_mood_ring}
    end
  end

  def update_confidence
    new_confidence = params[:mood_ring][:confidence].to_i
    session[:mood_ring].confidence = new_confidence
    @mood_ring = session[:mood_ring]
    respond_to do |format|
      format.js {render :update_mood_ring}
    end
  end

  private
  def post_params
    params.require(:mood_ring).permit(:mood, :optimistic, :comment)
  end
end

#Rails.logger.debug("Session")
#    session.keys.each{|k| Rails.logger.debug("#{k} => #{session[k]}")}
#    Rails.logger.debug("Params")
#    params.keys.each{|k| Rails.logger.debug("#{k} => #{params[k]}")}

  # def show
  #   session[:count] = 0
  #   session[:mood] = "happy"
  #   @mood = session[:mood]
  # end

  # def testajax
  #   @cart = session[:count]
  #   @mood = session[:mood]
  #   session[:mood] = session[:mood] == "happy" ? "sad" : "happy"
  #   session[:count] += 1
  # end



