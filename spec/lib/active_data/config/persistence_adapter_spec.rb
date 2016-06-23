# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Config::PersistenceAdapters do
  subject { described_class.new }

  before do
    class SomeClass; end
  end


  describe '#default' do
    specify do
      expect(subject.default).to eq ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord
    end
  end

  describe '#[]' do
    specify 'by default' do
      expect(subject).to receive(:normalize).with 1
      expect(subject[1]).to eq ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord
    end
  end

  describe '#[]=' do
    specify 'adapter is a class' do
      expect(subject).to receive(:normalize).once.with(1).and_return('2')
      expect(subject).to receive(:normalize).once.with('2').and_return('2')
      subject[1] = SomeClass
      expect(subject['2']).to eq SomeClass
    end

    specify 'adapter is not a class' do
      expect(subject).to receive(:normalize).once.with(1).and_return('2')
      expect(subject).to receive(:normalize).once.with(:some_class).and_return('SomeClass')
      expect(subject).to receive(:normalize).once.with('2').and_return('2')
      subject[1] = :some_class
      expect(subject['2']).to eq SomeClass
    end
  end

  describe '#normalize' do
    specify 'camelize string' do
      expect(subject.normalize('some_thing/here')).to eq 'SomeThing::Here'
    end

    specify 'camelize symbol' do
      expect(subject.normalize(:'some_thing/here')).to eq 'SomeThing::Here'
    end

    specify 'return name of a class' do
      expect(subject.normalize(SomeClass)).to eq 'SomeClass'
    end
  end

end
