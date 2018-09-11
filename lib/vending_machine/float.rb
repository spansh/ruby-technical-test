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

    def add_coin(denomination)
      unless @denomination_balances.has_key?(denomination)
        raise ArgumentError.new("Invalid coin inserted")
      end
      @denomination_balances[denomination] += 1
    end

    def remove_coin(denomination)
      unless @denomination_balances.has_key?(denomination)
        raise ArgumentError.new("Invalid coin requested")
      end
      unless @denomination_balances[denomination] > 0
        raise ArgumentError.new("No requested coins available")
      end
      @denomination_balances[denomination] -= 1
    end

    def request_change(amount)
      if amount > total
        raise ArgumentError.new("Not enough float to calculate change")
      end
      amounts = Hash.new(0)
      current_amount = 0
      [200,100,50,20,10,5,2,1].each { |denomination|
        while (denomination <= amount) && (current_amount + denomination <= amount) && (@denomination_balances[denomination] > 0)
          remove_coin(denomination)
          amounts[denomination] += 1
          current_amount += denomination
        end
      }
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
