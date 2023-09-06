# frozen_string_literal: true

class Checkout
  attr_reader :pricing_rules

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @basket = []
  end

  def scan(item)
    @basket << item
  end

  def total
    @pricing_rules.calculate_total(@basket)
  end
end
