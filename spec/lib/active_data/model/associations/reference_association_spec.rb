# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::ReferenceAssociation do
  before do
    stub_model(:book)
  end

  let(:reflection) { double }
  let(:persistence_adapter) { double }

  subject { described_class.new(Book.new, reflection) }

  describe '#scope' do
    before do
      allow(subject).to receive(:persistence_adapter).and_return persistence_adapter
    end

    context 'when source passed explicitly' do
      specify do
        expect(persistence_adapter).to receive(:scope).with(1).and_return 2
        expect(subject.scope(1)).to eq 2
      end
    end

    context 'be default' do
      specify do
        expect(subject).to receive(:read_source).and_return 1
        expect(persistence_adapter).to receive(:scope).with(1).and_return 2
        expect(subject.scope).to eq 2
      end
    end
  end

  describe '#persistence_adapter' do
    let(:scope_proc) { ->{} }
    before do
      allow(reflection).to receive(:klass).and_return Book
      allow(reflection).to receive(:primary_key).and_return :id
      allow(reflection).to receive(:scope_proc).and_return scope_proc
      allow(subject).to receive(:reflection).and_return reflection
    end

    specify do
      expect(ActiveData).to receive(:persistence_adapter).with(Book).and_return(persistence_adapter)
      expect(persistence_adapter).to receive(:call).with(Book, :id, scope_proc).and_return(1)
      expect(subject.persistence_adapter).to eq 1
    end
  end
end
