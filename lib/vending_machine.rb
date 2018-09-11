require "vending_machine/version"
require "vending_machine/float"
require "vending_machine/product"

class VendingMachine
  attr_reader :float, :products

  def initialize(
    float: VendingMachine::Float.new,
    products: []
  )
    @float = float
    @products = products
  end

end
