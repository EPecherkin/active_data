# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::ReferenceAssociation do
  before do
    stub_model(:book)
  end

  let(:persistence_adapter) { double }
  let(:reflection) { double(persistence_adapter: persistence_adapter) }
  subject { described_class.new(Book.new, reflection) }

  context 'discovery testing' do
    describe '#scope' do
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
  end
end
