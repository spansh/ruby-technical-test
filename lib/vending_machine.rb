require "vending_machine/version"
require "vending_machine/float"
require "vending_machine/product"

class VendingMachine
  attr_reader :float, :stock, :requested_stock, :paid
  # TODO: should requested_stock be an array to allow multiple products to be sold

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

  def restock(stock_index,amount)
    unless valid_stock?(stock_index)
      raise ArgumentError.new("Not a valid product to restock")
    end
    return @stock[stock_index].restock(amount)
  end

  def request_product(stock_index)
    if current_request?
      raise ArgumentError.new("Product has already been requested")
    end
    unless valid_stock?(stock_index)
      raise ArgumentError.new("Not a valid product to request")
    end
    unless @stock[stock_index].stock > 0
      raise ArgumentError.new("No stock for this product")
    end
    @requested_stock = stock_index
    @paid = VendingMachine::Float.new
    return @stock[@requested_stock].price
  end

  def remaining_cost
    unless current_request?
      raise ArgumentError.new("Product has not been requested")
    end
    return @stock[@requested_stock].price - @paid.total
  end

  def cancel_request
    unless current_request?
      raise ArgumentError.new("Product has not been requested")
    end
    change = @paid.denomination_balances
    @requested_stock = nil
    @paid = nil
    return change
  end

  def complete_request
    # TODO: handle ability to pay change with combination of paid and float
    # in instances where people pay small coins first and we have the capability
    # of paying the change
    unless current_request?
      raise ArgumentError.new("Product has not been requested")
    end
    @stock[@requested_stock].sell
    begin
      change = @float.request_change(remaining_cost * -1)
    rescue StandardError => e
      @stock[@requested_stock].restock(1)
      raise
    end

    @requested_stock = nil
    @paid = nil

    return change
  end

  def pay_coin(amount)
    unless current_request?
      raise ArgumentError.new("Product has not been requested")
    end
    paid.add_balance(amount)
    if remaining_cost <= 0
      return complete_request
    end

    return nil
  end

  private

  def current_request?
    if !defined? @requested_stock
      return false
    end
    if @requested_stock.nil?
      return false
    end
    return true
  end

  def valid_stock?(stock_index)
    if stock_index.nil? || @stock.length <= stock_index
      return false
    end
    return true
  end

end
