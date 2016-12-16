class MassMailController < ApplicationController

  ##  ID on the link is the url_code field in the MassEmail

  def unsubscribe
    id = params[:id]
    if !id
      @message = "This is a bad URL, we are confused!"
      @provide_email = false
    else
      mm = MassEmail.all.select{|m| m.url_code == id}
      if mm.length > 1
        Rails.logger.fatal("Unsubscribe has multiple IDS #{id}")
        @message = "This is a bad URL, we are confused!"
        @provide_email_link = true
      elsif mm.length == 0
        Rails.logger.fatal("Unsubscribe found no ID #{id}")
        @message = "We cannot find you, we are confused!"
        @provide_email_link = true
      else
        m = mm.first
        m.unsubscribed_at = Time.now
        if m.save
          @message = "Email #{m.email_address} has been successfully unsubscribed"
          @provide_email_link = false
        end
      end
    end
  end
end
