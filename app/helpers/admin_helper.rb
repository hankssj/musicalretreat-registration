module AdminHelper

  def indX(att, emphasize_if)
    code = att ? "Y" : "N"
    style = (att == emphasize_if) ? "reg-view-attribute-emphasized" : "reg-view-attribute-regular"
    "<span class=\"#{style}\">#{code}</span>"
  end
  
  def t_shirt_summary(counts)
    sum = ""
    counts.each_pair do |size, count| 	
      if count > 0
        sum += "#{size}/#{count} "
      end
    end
    sum
  end
  
  def meals_summary(meals, veg)
    if !meals
      '<span class="reg-view-attribute-emphasized">N</span>'
    elsif veg
      '<span class="reg-view-attribute-emphasized">Y (Veg)</span>'
    else
      '<span class="reg-view-attribute-regular">Y</span>'
    end
  end
  
  def comments_summary(comments)
    comments.strip()
    comments = "--none--" unless comments.size > 0
    "<span class=\"reg-view-value\">#{comments}</span>"
  end
  
  def instrument_summary(participant, instrument_name)
    unless participant
      "<span class=\"attribute-emphasized\">NON-PARTICIPANT<span>"
    else
      "<span class=\"attribute-regular\">#{instrument_name}</span>"
    end
  end

  def registration_date_summary(regdate)
    sprintf("<span class=\"reg-line-summary-attribute-regular\">%02s/%02i</span>", regdate.month, regdate.day)
  end
  
  def sort_link(title, column)
    current_key = params[:sort_key]
    current_direction = params[:sort_direction]
    if (column == current_key)
      new_direction = current_direction == "asc" ? "desc" : "asc"
    else
      new_direction = "asc"
    end
    link_to title, request.parameters.merge( {:sort_key => column, :sort_direction => new_direction} )  
  end
end
