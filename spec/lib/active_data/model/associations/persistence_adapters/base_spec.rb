# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::PersistenceAdapters::Base do
  before do
    stub_model(:author)
  end

  let(:primary_key) { :id }

  subject { described_class.new(Author, primary_key, nil) }

  describe '#find_one' do
    specify do
      expect(subject).to receive(:scope).with(1).and_return [2]
      expect(subject.find_one(1)).to eq 2
    end
  end

  describe '#find_all' do
    specify do
      expect(subject).to receive(:scope).with([1]).and_return [2]
      expect(subject.find_all([1])).to eq [2]
    end
  end

  describe '#scope' do
    specify do
      expect { subject.scope('something') } .to raise_error NotImplementedError
    end
  end

  describe '#primary_key_type' do
    specify do
      expect { subject.primary_key_type } .to raise_error NotImplementedError
    end
  end
end
