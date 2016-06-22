# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord do
  context 'discovery testing' do
    before do
      stub_model(:author, ActiveRecord::Base)
    end

    let(:primary_key) { :id }

    subject { described_class.new(Author, primary_key, nil) }

    describe '#find' do
      specify do
        expect(subject).to receive(:scope).with(1).and_return [2]
        expect(subject.find(1)).to eq 2
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
        expect(Author).to receive(:where).with(primary_key => 3).and_return 4
        expect(subject.scope(3)).to eq 4
      end

    end
  end
end
