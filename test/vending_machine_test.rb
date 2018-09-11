require "test/unit"
require "vending_machine"

class VendingMachineTest < Test::Unit::TestCase
  def test_constructor
    vm = VendingMachine.new
    assert_not_nil(vm,'Basic constructor was not successful')
  end
end
