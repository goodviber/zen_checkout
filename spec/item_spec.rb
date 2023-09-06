# frozen_string_literal: true

require 'spec_helper'

describe Item do
  subject { described_class.new(code: '001', price: 9.25) }

  it 'has a code' do
    expect(subject.code).to eq('001')
  end

  it 'has a price' do
    expect(subject.price).to eq(9.25)
  end
end
