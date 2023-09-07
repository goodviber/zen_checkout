# frozen_string_literal: true

class Checkout
  attr_reader :pricing_rules, :discount_manager, :basket

  def initialize(pricing_rules = [])
    @discount_manager = DiscountManager.new(pricing_rules)
    @pricing_rules = pricing_rules
    @basket = []
  end

  def scan(item)
    @basket << item
  end

  def total
    price = 0
    basket.tally.each do |item, quantity|
      # catch the case where there are no pricing rules
      price += if discount_manager.pricing_rules.none?
                 item.price * quantity
               else
                 discount_manager.discount_price_for(item, quantity)
               end
    end
    discount_manager.discount_total(price)
  end
end
