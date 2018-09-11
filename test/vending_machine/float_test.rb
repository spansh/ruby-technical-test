require "test/unit"
require "vending_machine/float"

class VendingMachineFloatTest < Test::Unit::TestCase
  def test_constructor
    float = VendingMachine::Float.new
    assert_not_nil(float,"Basic constructor was not successful")
    assert_equal(0,float.total,"Constructor created no total")
    float = VendingMachine::Float.new(balances: { 1 => 1 })
    assert_equal(1,float.total,"Constructor passed 1 pence failed")
    float = VendingMachine::Float.new(balances: { 1 => 1, 2 => 1, 5 => 1, 10 => 1, 20 => 1, 50 => 1, 100 => 1, 200 => 1 })
    assert_equal(388,float.total,"Constructor passed 1 of each coin failed")

    assert_raise ArgumentError,"Adding negative coin should have raised" do
      VendingMachine::Float.new(balances: { 1 => -1 })
    end
    #TODO: handle this with an exception
    float = VendingMachine::Float.new(balances: { 123 => 1 })
    assert_equal(0,float.total,"Constructor accepted invalid coin")
  end

  def test_add_balance
    float = VendingMachine::Float.new
    float.add_balance(1)
    assert_equal(1,float.total,"Adding 1 pence failed")
    float.add_balance(2)
    assert_equal(3,float.total,"Adding 2 pence failed")
    float.add_balance(5)
    assert_equal(8,float.total,"Adding 5 pence failed")
    float.add_balance(10)
    assert_equal(18,float.total,"Adding 10 pence failed")
    float.add_balance(20)
    assert_equal(38,float.total,"Adding 20 pence failed")
    float.add_balance(50)
    assert_equal(88,float.total,"Adding 50 pence failed")
    float.add_balance(100)
    assert_equal(188,float.total,"Adding 1 pound failed")
    float.add_balance(200)
    assert_equal(388,float.total,"Adding 2 pounds failed")
    assert_raise ArgumentError,"Adding invalid coin should have raised" do
      float.add_balance(123)
    end
  end

  def test_add_balance
    float = VendingMachine::Float.new(balances: { 1 => 1, 2 => 1, 5 => 1, 10 => 1, 20 => 1, 50 => 1, 100 => 1, 200 => 1 })
    float.remove_balance(1)
    assert_equal(387,float.total,"Removing 1 pence failed")
    assert_raise ArgumentError,"No 1 pence coins left should have raised" do
      float.remove_balance(1)
    end
    float.remove_balance(2)
    assert_equal(385,float.total,"Removing 2 pence failed")
    assert_raise ArgumentError,"No 2 pence coins left should have raised" do
      float.remove_balance(2)
    end
    float.remove_balance(5)
    assert_equal(380,float.total,"Removing 5 pence failed")
    assert_raise ArgumentError,"No 5 pence coins left should have raised" do
      float.remove_balance(5)
    end
    float.remove_balance(10)
    assert_equal(370,float.total,"Removing 10 pence failed")
    assert_raise ArgumentError,"No 10 pence coins left should have raised" do
      float.remove_balance(10)
    end
    float.remove_balance(20)
    assert_equal(350,float.total,"Removing 20 pence failed")
    assert_raise ArgumentError,"No 20 pence coins left should have raised" do
      float.remove_balance(20)
    end
    float.remove_balance(50)
    assert_equal(300,float.total,"Removing 50 pence failed")
    assert_raise ArgumentError,"No 50 pence coins left should have raised" do
      float.remove_balance(50)
    end
    float.remove_balance(100)
    assert_equal(200,float.total,"Removing 1 pound failed")
    assert_raise ArgumentError,"No 1 pound coins left should have raised" do
      float.remove_balance(100)
    end
    float.remove_balance(200)
    assert_equal(0,float.total,"Removing 2 pounds failed")
    assert_raise ArgumentError,"No 2 pound coins left should have raised" do
      float.remove_balance(200)
    end
    float = VendingMachine::Float.new(balances: { 1 => 1 })
    assert_raise ArgumentError,"Should have raised an error when removing more 1 pence than available" do
      float.remove_balance(1,2)
    end
  end

  def test_request_change
    float = VendingMachine::Float.new(balances: { 1 => 1, 2 => 1, 5 => 1, 10 => 1, 20 => 1, 50 => 1, 100 => 1, 200 => 1 })
    assert_raise ArgumentError,"Requested more change than available should have raised" do
      float.request_change(389)
    end
    assert_equal({ 1 => 1 },float.request_change(1),'1 pence change was not calculated correctly')
    assert_equal({ 2 => 1, 5 => 1, 10 => 1, 20 => 1, 50 => 1, 100 => 1, 200 => 1 },float.request_change(387),'Every coin except 1 pence change was not calculated correctly')
    float = VendingMachine::Float.new(balances: { 1 => 2 })
    assert_equal({ 1 => 2 },float.request_change(2),'2 pence change with no 2 pence was not calculated correctly')
    float = VendingMachine::Float.new(balances: { 1 => 100, 2 => 100, 5 => 100, 10 => 100, 20 => 100, 50 => 100, 100 => 100, 200 => 100 })
    assert_equal({ 200 => 6, 50 => 1, 10 => 1, 5 => 1, 2 => 1, 1 => 1 },float.request_change(1268),'2 pence change with no 2 pence was not calculated correctly')
  end
end
