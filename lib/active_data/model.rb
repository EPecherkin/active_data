require 'active_data/model/conventions'
require 'active_data/model/attributes'
require 'active_data/model/scopes'
require 'active_data/model/primary'
require 'active_data/model/lifecycle'
require 'active_data/model/persistence'
require 'active_data/model/callbacks'
require 'active_data/model/associations'
require 'active_data/model/validations'
require 'active_data/model/localization'
require 'active_data/model/dirty'

module ActiveData
  module Model
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      include ActiveModel::Conversion
      include ActiveModel::Serialization
      include ActiveModel::Serializers::JSON

      include Conventions
      include Attributes
      include Validations
    end

    # TODO find better way to do that
    module ClassMethods
      def reset_caches!
        self.reflections.values.each(&:reset_instance_variables_cache!)
      end

      def reset_persistence_adapters_cache!
        self.reflections.values.each(&:reset_persistence_adapter_cache!)
      end

      def reset_klass_caches!
        self.reflections.values.each(&:reset_klass_cache!)
      end
    end
  end
end
