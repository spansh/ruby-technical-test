require "test/unit"
require "vending_machine"
require "vending_machine/product"

class VendingMachineTest < Test::Unit::TestCase
  def test_constructor
    vm = VendingMachine.new
    assert_not_nil(vm,"Basic constructor was not successful")
    vm = VendingMachine.new(stock: [VendingMachine::Product.new(name: "Marshmallow", price: 101, stock: 100)])
    assert_equal("Marshmallow",vm.stock[0].name,"First stock item was not marshmallow")
  end

  def test_restock
    vm = VendingMachine.new(
      stock: [
        VendingMachine::Product.new(name: "Marshmallow", price: 101, stock: 100),
        VendingMachine::Product.new(name: "Fruit Gums", price: 99, stock: 50)
      ]
    )
    assert_equal("Fruit Gums",vm.stock[1].name,"Second stock item was not fruit gums")
    assert_equal(110,vm.restock(0,10),"Marshmallow was restocked to 110")
    assert_equal(50,vm.stock[1].stock,"Fruit gums were not restocked")
    assert_raise ArgumentError,"Was able to restock non existant item" do 
      vm.restock(2,1)
    end
    assert_raise ArgumentError,"Was able to restock a negative number" do 
      vm.restock(1,-11)
    end
  end

  def test_request_product_and_cancel
    vm = VendingMachine.new(
      stock: [
        VendingMachine::Product.new(name: "Marshmallow", price: 101, stock: 100),
        VendingMachine::Product.new(name: "Fruit Gums", price: 99, stock: 50),
        VendingMachine::Product.new(name: "Dairy Milk", price: 199, stock: 0)
      ]
    )
    assert_equal(101,vm.request_product(0),"Was unable to request a valid product")
    assert_raise ArgumentError,"Was able to request a second product" do
      vm.request_product(0)
    end
    vm.cancel_request
    assert_equal(101,vm.request_product(0),"Was able to request a valid product after cancelling")
    vm.cancel_request
    assert_raise ArgumentError,"Was able to request a product with no stock" do
      vm.request_product(2)
    end
    assert_raise ArgumentError,"Was able to request a product which does not exist" do
      vm.request_product(3)
    end
  end

  def test_remaining_cost
    vm = VendingMachine.new(
      stock: [
        VendingMachine::Product.new(name: "Marshmallow", price: 101, stock: 100),
        VendingMachine::Product.new(name: "Fruit Gums", price: 99, stock: 50),
        VendingMachine::Product.new(name: "Dairy Milk", price: 199, stock: 0)
      ]
    )
    vm.request_product(1)
    assert_equal(99,vm.remaining_cost,"Cost was calculated correctly for requested product")
    vm.pay_coin(1)
    assert_equal(98,vm.remaining_cost,"Cost was calculated correctly for requested product after paying 1 pence")
    vm.cancel_request
    assert_raise ArgumentError,"Cost was calculated with no request" do
      vm.remaining_cost
    end
  end

  def test_complete_request
    vm = VendingMachine.new(
      stock: [
        VendingMachine::Product.new(name: "Marshmallow", price: 101, stock: 100),
        VendingMachine::Product.new(name: "Fruit Gums", price: 99, stock: 50),
        VendingMachine::Product.new(name: "Dairy Milk", price: 199, stock: 0)
      ],
      float: VendingMachine::Float.new(balances: { 1 => 100, 2 => 100, 5 => 100, 10 => 100, 20 => 100, 50 => 100, 100 => 100, 200 => 100 })
    )
    vm.request_product(1)
    assert_nil(vm.pay_coin(1),"Paying 1 pence was not enough for product so should have returned nil")
    change = vm.pay_coin(200)
    # 201 paid, 102 returned
    assert_equal({ 100 => 1, 2 => 1},change,"Change was not calculated correctly")
    vm.request_product(1)
    assert_nil(vm.pay_coin(50),"Adding 50 pence should not trigger complete")
    assert_nil(vm.pay_coin(20),"Adding first 20 pence should not trigger complete")
    assert_nil(vm.pay_coin(20),"Adding second 20 pence should not trigger complete")
    assert_nil(vm.pay_coin(5),"Adding 5 pence should not trigger complete")
    assert_nil(vm.pay_coin(2),"Adding first 2 pence should not trigger complete")
    change = vm.pay_coin(2)
    assert_equal({},change,"No change should be returned for exact money")
  end
end
