# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::Reflections::ReferenceReflection do
  before do
    stub_model(:author)
  end

  let(:options) { {primary_key: :id} }

  subject { described_class.new(:author, options) }

  describe '#persistence_adapter' do
    let(:persistence_adapter) { double }

    specify do
      expect(ActiveData).to receive(:persistence_adapter).with(Author).and_return(persistence_adapter)
      expect(persistence_adapter) .to receive(:call).with(Author, options[:primary_key], nil).and_return(1)
      expect(subject.persistence_adapter).to eq 1
    end
  end
end
