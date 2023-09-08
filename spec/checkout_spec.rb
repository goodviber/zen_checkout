# frozen_string_literal: true

require 'spec_helper'

describe Checkout do
  let(:pricing_rules) do
    [
      PricingRule.discount_rule(200, 10),
      PricingRule.multibuy_rule('A', 2, 90),
      PricingRule.multibuy_rule('B', 3, 75),
      PricingRule.percentage_discount_rule('D', 100, 10)
    ]
  end
  subject(:no_rules) { described_class.new }
  subject(:with_rules) { described_class.new(pricing_rules) }
  let(:item_a) { Item.new(code: 'A', price: 50) }
  let(:item_b) { Item.new(code: 'B', price: 30) }
  let(:item_c) { Item.new(code: 'C', price: 20) }
  let(:item_d) { Item.new(code: 'D', price: 100) }

  describe 'on setup' do
    it 'should have an empty basket' do
      expect(subject.basket.count).to eq(0)
    end

    it 'should have zero total price' do
      expect(subject.total).to eq(0)
    end
  end

  describe '#scan' do
    it 'should add items to the basket' do
      subject.scan(item_a)
      subject.scan(item_b)
      expect(subject.basket.count).to eq(2)
    end
  end

  describe '#total' do
    context 'with no pricing rules' do
      it 'should return the total price of the basket' do
        no_rules.scan(item_a)
        no_rules.scan(item_a)
        no_rules.scan(item_a)
        no_rules.scan(item_a)
        no_rules.scan(item_b)
        no_rules.scan(item_c)
        expect(no_rules.total).to eq(250)
      end

      context 'all D items are not discounted' do
        it 'should apply discount correctly' do
          no_rules.scan(item_d)
          no_rules.scan(item_d)
          expect(no_rules.total).to eq(200)
        end
      end
    end

    context 'with pricing rules' do
      context 'with no discounts' do
        it 'should return the total price of the basket' do
          with_rules.scan(item_a)
          with_rules.scan(item_b)
          with_rules.scan(item_c)
          expect(with_rules.total).to eq(100)
        end
      end

      context 'with qualifying total sum' do
        it 'should apply discount correctly' do
          with_rules.scan(item_a)
          with_rules.scan(item_b)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          with_rules.scan(item_c)
          expect(with_rules.total).to eq(252)
        end
      end

      context 'with qualifying products and less than qualifying total sum' do
        it 'should apply discount correctly' do
          with_rules.scan(item_a)
          with_rules.scan(item_b)
          with_rules.scan(item_b)
          with_rules.scan(item_b)
          with_rules.scan(item_a)
          expect(with_rules.total).to eq(165)
        end
      end

      context 'with qualifying products and qualifying total sum' do
        it 'should apply discount correctly' do
          with_rules.scan(item_c)
          with_rules.scan(item_b)
          with_rules.scan(item_a)
          with_rules.scan(item_a)
          with_rules.scan(item_c)
          with_rules.scan(item_b)
          with_rules.scan(item_c)
          expect(with_rules.total).to eq(189)
        end
      end

      context 'all D items are discounted' do
        it 'should apply discount correctly' do
          with_rules.scan(item_d)
          with_rules.scan(item_d)
          expect(with_rules.total).to eq(180)
        end
      end
    end
  end
end
