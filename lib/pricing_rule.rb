# frozen_string_literal: true

class PricingRule
  attr_reader :type, :block

  TYPE = { discount: 1, multibuy: 2, percentage_discount: 3 }.freeze

  def initialize(type, &block)
    @type = type
    @block = block
  end

  def apply(*items)
    block.call(*items)
  end

  def self.discount_rule(minimum_spend, percentage_discount)
    PricingRule.new(PricingRule::TYPE[:discount]) do |sum_total|
      sum_total >= minimum_spend ? (sum_total - (sum_total * percentage_discount / 100)) : sum_total
    end
  end

  def self.multibuy_rule(item_code, qualifying_quantity, discount_price)
    PricingRule.new(PricingRule::TYPE[:multibuy]) do |code, quantity|
      discount_price if code == item_code && quantity >= qualifying_quantity
    end
  end

  def self.percentage_discount_rule(item_code, original_price, percentage_discount)
    PricingRule.new(PricingRule::TYPE[:percentage_discount]) do |code|
      original_price - (original_price * percentage_discount / 100) if code == item_code
    end
  end
end
