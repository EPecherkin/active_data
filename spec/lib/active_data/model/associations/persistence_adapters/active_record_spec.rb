# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord do
  before do
    stub_model(:author, ActiveRecord::Base)
  end

  let(:primary_key) { :id }

  subject { described_class.new(Author, primary_key, nil) }

  describe '#scope' do
    let(:unscoped) { double }

    specify do
      expect(Author).to receive(:unscoped).and_return unscoped
      expect(unscoped).to receive(:where).with(primary_key => 3).and_return 4
      expect(ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord::ScopeProxy).to receive(:new).with(4).and_return 1
      expect(subject.scope(3)).to eq 1
    end
  end

  describe '#primary_key_type' do
    let(:type) { double(type: :integer) }

    specify do
      expect(Author).to receive(:columns_hash).and_return 'id' => type
      expect(subject.primary_key_type).to eq Integer
    end
  end
end
