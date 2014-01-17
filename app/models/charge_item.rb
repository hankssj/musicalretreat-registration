class ChargeItem
  
  attr_reader :name, :price
  attr_accessor :quantity
  
  def initialize(name, price, quantity)
    @name = name
    @price = price
    @quantity = quantity
  end
  
  def increment_quantity
    quantity += 1
  end
  
  def decrement_quantity
    if (quantity < 0)
      raise("Tried to push quantity below 0")
    end
    quantity -= 1
  end
  
  def empty
    quantity == 0
  end
  
  def total
    quantity * price
  end
end
