# encoding: UTF-8
require 'spec_helper'

describe ActiveData do
  specify { expect(subject).to respond_to :include_root_in_json }
  specify { expect(subject).to respond_to :include_root_in_json= }
  specify { expect(subject).to respond_to :i18n_scope }
  specify { expect(subject).to respond_to :i18n_scope= }
  specify { expect(subject).to respond_to :primary_attribute }
  specify { expect(subject).to respond_to :primary_attribute= }
  specify { expect(subject).to respond_to :normalizer }

  describe '#persistence_adapter' do
    specify 'default value' do
      expect(subject.persistence_adapter).to eq ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord
    end
  end
end
