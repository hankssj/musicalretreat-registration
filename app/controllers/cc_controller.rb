class CcController < ApplicationController
  
  #  Depart comes from the registration controller;  Right now we need to dispatch 
  #  first to our own page, which will say something inane then post to the gateway.
  #  This because Paypal needs a post, and we can't redirect to a POST, as far as I 
  #  can tell.   

  def depart
    @registration = Registration.find(params[:id])
    @payment_mode = @registration.payment_mode
    @payment_net = @registration.payment_net
    @credit_card_charge = @registration.credit_card_charge
    @payment_gross = @payment_net + @credit_card_charge

    Event.log("Depart on #{@registration.id} with payment amount #{@amount}")
    Event.log("  Payment mode: #{@registration.payment_mode}, balance #{@registration.balance}, cc #{@registration.credit_card_charge}, deposit #{@registration.deposit}")
    # Event.log("  Payment amounts #{@registration.payments.map{|p|p.amount}.join(', ')}")

    if @amount == 0
      flash[:notice] = "No balance or deposit to pay"
      redirect_to :controller => :registration, :action => :index
    end

    #  Shouldn't this go in a config file?  Maybe, if it's the only one.  Maybe not, if it is
    @user = "treasurer.mmr@gmail.com"
    @cmd = "_xclick"
    @item_name = "MMR Registration"
    @quantity = 1
    @amount = @amount

    @no_note = 1
    @no_shipping = 1
    @rm = 2   #  post back to the thanks page
    @cbt = "Return to the Registration Site"
    #  Should be passed back to us in both the return URL and the IPN notification?
    @custom = @registration.id

    ## For fill in ... 
    @address_override = 1
    @first_name = @registration.first_name
    @last_name = @registration.last_name
    @address1 = @registration.street1
    @address2 = @registration.street2
    @city = @registration.city
    @country = @registration.country
    @email = @registration.user.email
    @night_phone_a = @registration.primaryphone
    @state = @registration.state
    @zip = @registration.zip
  end

  #  This is coming back from the payment gateway with success.
  #  I guess we know that the amount sent out was actually charged?
  #  Better have some token in the params!
  def return
    post_data = request.env['RAW_POST_DATA']
    File.open(File.join(Rails.root, 'tmp', 'return_msgs.txt'), "a") do |f|
      f.puts "==================="
      f.puts "#{Time.now} / #{post_data || 'No Post Data'}"
    end
    if (post_data && post_data["custom"])
      redirect_to :controller => :registration, :action => :confirm_registration, :id => post_data["custom"]
    else
      flash[:notice] = "Payment Successfully Recorded"
      redirect_to :controller => :registration, :action => :index
    end
  end
  
  def ipn_listen
    post_data = request.env['RAW_POST_DATA'] || "NO POST DATA"
    File.open(File.join(Rails.root, 'tmp', 'ipn_msgs.txt'), "a") do |f|
      f.puts "==================="
      f.puts "#{Time.now} / #{post_data}"
      if params[:payment_status] != "Completed"
        f.puts "No payment created, payment status is #{params[:payment_status]}"
      elsif params[:custom] 
        r = Registration.find_by_id(params[:custom])
        if r
          Event.log("Arrive with reg ID #{r.id}, payment mode #{r.payment_mode}")
          if r.payment_mode == "deposit_cc"
            amt = r.deposit
          elsif r.payment_mode == "balance_cc"
            amt = r.balance
          else
            Event.log("   Bad payment mode #{r.payment_mode}")
            ##raise "Bad payment mode on return payment -- got #{r.payment_mode}"
          end
          Event.log("  Amount set to #{amt}, balance is #{r.balance}")
          Payment.create!(:registration_id => r.id, 
                          :amount => amt, 
                          :check_number => "Online/CC", 
                          :date_received => Date.today,
                          :online => true,
                          :confirmed => false)
          f.puts "Created payment for reg ID #{r.id} and amount #{amt}"
        else
          f.puts "No registration for #{params[:custom]}"
        end
      else
        f.puts "Callback has no custom field!"
      end
    end
    render :nothing => true
  end
end
