# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::Reflections::ReferenceReflection do
  context 'discovery testing' do
    before do
      stub_model(:author)
    end

    subject(:reflection) { described_class.new(:author, options) }

    describe '#persistence_adapter' do
      subject { reflection.persistence_adapter }

      let(:persistence_adapter) { double }

      before do
        allow(persistence_adapter).to receive(:new).with(Author, :id, nil).and_return(1)
      end

      context 'when explicitly declared' do
        let(:options) { {persistence_adapter: persistence_adapter} }

        it { is_expected.to eq 1 }
      end

      context 'by default' do
        before do
          allow(ActiveData).to receive(:persistence_adapter).and_return(persistence_adapter)
        end

        let(:options) { Hash.new }

        it { is_expected.to eq 1 }
      end
    end
  end
end
