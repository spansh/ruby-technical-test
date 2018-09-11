require "vending_machine/version"
require "vending_machine/float"
require "vending_machine/product"

class VendingMachine
  attr_reader :float, :stock, :requested_stock, :paid

  def initialize(
    float: VendingMachine::Float.new,
    stock: []
  )
    @float = float
    @stock = stock 
  end

  def add_new_product(product)
    @stock << product
    return @stock.length + 1
  end

  def restock_product(stock_index,amount)
    unless @stock.length < stock_index
      raise ArgumentError.new("Not a valid product")
    end
    @stock[stock_index].restock(amount)
  end

end
