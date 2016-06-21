# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::Reflections::ReferenceReflection do
  context 'discovery' do
    let(:persistence_adapter) { double }
    let(:options) { {persistence_adapter: persistence_adapter} }

    subject(:reflection) { described_class.new(:author, options) }

    describe '#persistence_adapter' do
      subject { reflection.persistence_adapter }

      context 'when explicitly declared' do
        it { is_expected.to eq persistence_adapter }
      end

      context 'by default' do
        before do
          allow(ActiveData).to receive(:persistence_adapter).and_return(1)
        end

        let(:options) { Hash.new }

        it { is_expected.to eq 1 }
      end
    end
  end
end
