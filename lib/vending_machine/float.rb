require "vending_machine/exceptions"

class VendingMachine
  class Float
    attr_reader :denomination_balances
    # TODO: extend to handle notes seperately
    def initialize(balances: {})
      @denomination_balances = {}
      [200,100,50,20,10,5,2,1].each { |denomination|
        @denomination_balances[denomination] = 0
        if balances.key?(denomination)
          if balances[denomination] < 0
            raise ArgumentError.new("Attempted to start with negative float")
          end
          @denomination_balances[denomination] += balances[denomination].to_i
        end
      }
    end

    def consume(float)
      unless (float.is_a?(VendingMachine::Float))
        raise TypeError.new("Can only merge with another float object")
      end

      [200,100,50,20,10,5,2,1].each { |denomination|
        amount = float.denomination_balances[denomination]
        float.remove_balance(denomination,amount)
        add_balance(denomination,amount)
      }
    end

    def add_balance(denomination, amount = 1)
      unless @denomination_balances.has_key?(denomination)
        raise ArgumentError.new("Invalid demomination inserted")
      end
      @denomination_balances[denomination] += amount
    end

    def remove_balance(denomination, amount = 1)
      unless @denomination_balances.has_key?(denomination)
        raise ArgumentError.new("Invalid denomination requested")
      end
      unless @denomination_balances[denomination] >= amount
        raise VendingMachine::FloatError.new("Not enough requested denomination available")
      end
      @denomination_balances[denomination] -= amount
    end

    def request_change(amount)
      if amount > total
        raise VendingMachine::FloatError.new("Not enough float to calculate change")
      end
      amounts = Hash.new(0)
      current_amount = 0
      [200,100,50,20,10,5,2,1].each { |denomination|
        while (denomination <= amount) && (current_amount + denomination <= amount) && (@denomination_balances[denomination] > 0)
          remove_balance(denomination)
          amounts[denomination] += 1
          current_amount += denomination
        end
      }
      if current_amount != amount
        raise VendingMachine::FloatError.new("Cannot make up change with available coins")
      end
      return amounts
    end

    def total
      current_total = 0
      @denomination_balances.each {|denomination, count|
        current_total += count*denomination
      }
      return current_total
    end
  end
end
