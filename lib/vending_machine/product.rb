class VendingMachine::Product
  attr_reader :name, :price, :stock

  def initialize(name: nil, price: nil, stock: 0)
    if name.nil?
      raise ArgumentError.new("Product name cannot be nil")
    end
    if price.nil? || price < 1
      raise ArgumentError.new("product price must be positive")
    end
    @name = name
    @price = price
    @stock = stock
  end

  def restock(amount)
    if amount < 1
      raise ArgumentError.new("Restocking a negative amount")
    end
    @stock += amount
    return @stock
  end

  def sell
    if @stock < 1
      raise ArgumentError.new("No stock left")
    end
    @stock -= 1
    return @stock
  end
end
