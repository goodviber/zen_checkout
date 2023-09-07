# frozen_string_literal: true

class DiscountManager
  attr_reader :pricing_rules

  def initialize(pricing_rules = [])
    @pricing_rules = pricing_rules
  end

  def discount_price_for(item, quantity)
    discount_price = nil
    pricing_rules.each do |rule|
      discount_price = rule.apply(item.code, quantity) if rule.type == PricingRule::TYPE[:multibuy]
      return discount_price unless discount_price.nil?
    end
    item.price * quantity
  end

  def discount_total(total)
    pricing_rules.each do |rule|
      total = rule.apply(total) if rule.type == 1
    end
    total
  end
end
