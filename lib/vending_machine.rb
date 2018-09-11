require "vending_machine/version"
require "vending_machine/float"
require "vending_machine/products"

class VendingMachine
  attr_reader :float, :products

  def initialize(
    float: VendingMachine::Float.new,
    products: VendingMachine::Products.new
  )
    @float = float
    @products = products
  end

end
