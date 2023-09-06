# frozen_string_literal: true

require 'spec_helper'

describe DiscountManager do
  let(:pricing_rules) do
    [
      PricingRule.discount_rule(60, 10),
      PricingRule.multibuy_rule('001', 2, 8.5)
    ]
  end
  let(:item) { Struct.new(:code, :price).new('001', 20) }
  subject { described_class.new(pricing_rules) }

  describe '#discount_price_for' do
    it 'should pass the params to the pricing rule' do
      expect(pricing_rules[1]).to receive(:type) { PricingRule::TYPE[:multibuy] }
      expect(pricing_rules[1]).to receive(:apply).with('001', 2)

      subject.discount_price_for(item, 2)
    end

    it 'should return the discounted price when rule applied' do
      price = subject.discount_price_for(item, 2)
      expect(price).to eq(8.5)
    end

    it 'should return the original price when no rule applied' do
      price = subject.discount_price_for(item, 1)
      expect(price).to eq(item.price)
    end
  end

  describe '#discount_total' do
    it 'should pass the calculation to the promo_rule with total' do
      expect(pricing_rules.first).to receive(:type) { PricingRule::TYPE[:discount] }
      expect(pricing_rules.first).to receive(:apply).with(20)

      subject.discount_total(20)
    end

    it 'should return the calculated total when rule applied' do
      total = subject.discount_total(100)
      expect(total).to eq(90)
    end

    it 'should return original subtotal if no rule match' do
      discount_manager = DiscountManager.new

      total = discount_manager.discount_total(10)
      expect(total).to eq(10)
    end
  end
end
