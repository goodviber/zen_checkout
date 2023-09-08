# frozen_string_literal: true

class DiscountManager
  attr_reader :pricing_rules

  def initialize(pricing_rules = [])
    @pricing_rules = pricing_rules
  end

  def discount_price_for(item, quantity)
    discount_price = 0
    pricing_rules.each do |rule|
      discount_price += rule.apply(item.code, quantity) || 0 unless rule.type == PricingRule::TYPE[:discount]
    end
    return discount_price unless discount_price.zero?

    item.price.to_f * quantity
  end

  def discount_total(total)
    pricing_rules.each do |rule|
      total = rule.apply(total) if rule.type == PricingRule::TYPE[:discount]
    end
    total
  end
end
