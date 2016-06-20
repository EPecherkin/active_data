# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord::ScopeProxy do
  let(:scope) { double }

  subject { described_class.new(scope) }

  describe '#method_missing' do
    specify 'exesiting method' do
      expect(subject).to receive(:delegate_to_original_scope?).with(:foo).and_return(true)
      expect(scope).to receive(:foo).and_return('bar')
      expect(subject.foo).to eq 'bar'
    end

    specify 'unknown method' do
      expect(subject).to receive(:delegate_to_original_scope?).with(:foo2).and_return(false)
      expect(scope).not_to receive(:foo2)
      expect { subject.foo2 }.to raise_error NoMethodError
    end
  end

  describe '#respond_to_missing?' do
    specify 'exesiting method' do
      expect(subject).to receive(:delegate_to_original_scope?).with(:foo).and_return(true)
      expect(subject.respond_to?(:foo)).to be_truthy
    end

    specify 'unknown method' do
      expect(subject).to receive(:delegate_to_original_scope?).with(:foo2).and_return(false)
      expect(subject.respond_to?(:foo2)).to be_falsy
    end
  end

  describe '#delegate_to_original_scope?' do
    before do
      stub_const('ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord::ScopeProxy::METHODS_EXCLUDED_FROM_DELEGATION', [:build])
      allow(scope).to receive(:foo)
    end

    specify 'allowed method and persisted' do
      expect(subject.delegate_to_original_scope?(:foo)).to be_truthy
    end

    specify 'excluded method' do
      expect(subject.delegate_to_original_scope?(:build)).to be_falsy
    end

    specify 'unknown method' do
      expect(subject.delegate_to_original_scope?(:foo2)).to be_falsy
    end
  end
end
