class PaymentTestController < ApplicationController

  def index
    @user = "seller_1261683294_biz@pobox.com"
    @cmd = "_xclick"
    @item_name = "Registration"
    @quantity = 1
  end
end

