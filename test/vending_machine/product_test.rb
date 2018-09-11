require "test/unit"
require "vending_machine/product"

class VendingMachineProductTest < Test::Unit::TestCase
  def test_constructor
    assert_raise ArgumentError,"Unsupplied name did not fail" do
      VendingMachine::Product.new(price: 1)
    end
    assert_raise ArgumentError,"Unsupplied price did not fail" do
      VendingMachine::Product.new(name: "Marshmallow")
    end
    assert_raise ArgumentError,"Negative price did not fail" do
      VendingMachine::Product.new(name: "Marshmallow", price: -1)
    end
    product = VendingMachine::Product.new(name: "Marshmallow", price: 100, stock: 10)
    assert_not_nil(product,"Basic instance was not created")
  end

  def test_restock
    product = VendingMachine::Product.new(name: "Marshmallow", price: 100, stock: 10)
    assert_equal(10,product.stock,"10 stock before restock")
    assert_equal(20,product.restock(10),"Restock did not add product")
    assert_raise ArgumentError,"Negative restock did not fail" do
      product.restock(-1)
    end
  end

  def test_sell
    product = VendingMachine::Product.new(name: "Marshmallow", price: 100, stock: 2)
    assert_equal(1,product.sell,"Selling product did not reduce stock")
    assert_equal(0,product.sell,"Selling product did not reduce stock to 0")
    assert_raise ArgumentError,"Sell did not fail when no stock left" do
      product.sell
    end
  end
end
