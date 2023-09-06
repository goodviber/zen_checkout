# frozen_string_literal: true

require 'spec_helper'

describe PricingRule do
  subject { described_class.new(PricingRule::TYPE[:discount]) }

  describe '#type' do
    it 'returns the type of the pricing rule' do
      expect(subject.type).to eq(1)
    end
  end

  describe '#apply' do
    it 'should call the block with no arguments' do
      pricing_rule = described_class.new(PricingRule::TYPE[:discount]) do
        'hello'
      end
      expect(pricing_rule.apply).to eq('hello')
    end

    it 'should call the block with one argument' do
      pricing_rule = described_class.new(PricingRule::TYPE[:discount]) do |arg|
        arg
      end
      expect(pricing_rule.apply('hello')).to eq('hello')
    end

    it 'should call the block with two arguments' do
      pricing_rule = described_class.new(PricingRule::TYPE[:discount]) do |arg1, arg2|
        arg1 + arg2
      end
      expect(pricing_rule.apply(1, 2)).to eq(3)
    end
  end

  describe '.discount_rule' do
    subject { PricingRule.discount_rule(60, 10) }

    it 'should return a pricing rule' do
      expect(subject).to be_a(PricingRule)
    end

    it 'should return the discounted price if the total is greater than the minimum spend' do
      discount = subject.apply(61.00)
      expect(discount).to eq(54.9)
    end

    it 'should return the discounted price if the total is equal to the minimum spend' do
      discount = subject.apply(60.00)
      expect(discount).to eq(54)
    end
  end

  describe '.multibuy_rule' do
    subject { PricingRule.multibuy_rule('001', 2, 8.5) }

    it 'should return a pricing rule' do
      expect(subject).to be_a(PricingRule)
    end

    it 'should return the discount price if the quantity is equal to the qualifying quantity' do
      discount_rule = PricingRule.multibuy_rule('001', 2, 8.5)
      expect(discount_rule.apply('001', 2)).to eq(8.5)
    end

    it 'should return the discount price if the quantity is greater than the qualifying quantity' do
      discount_rule = PricingRule.multibuy_rule('001', 2, 8.5)
      expect(discount_rule.apply('001', 3)).to eq(8.5)
    end

    it 'should return nil if the quantity is less than the qualifying quantity' do
      discount_rule = PricingRule.multibuy_rule('001', 2, 8.5)
      expect(discount_rule.apply('001', 1)).to eq(nil)
    end

    it 'should return nil if the product code is different' do
      discount_rule = PricingRule.multibuy_rule('001', 2, 8.5)
      expect(discount_rule.apply('002', 2)).to eq(nil)
    end
  end
end
