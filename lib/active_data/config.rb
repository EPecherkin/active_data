module ActiveData
  class Config
    include Singleton

    attr_accessor :include_root_in_json, :i18n_scope, :logger, :primary_attribute,
      :_normalizers, :_typecasters

    attr_reader :persistence_adapters

    def self.delegated
      public_instance_methods - superclass.public_instance_methods - Singleton.public_instance_methods
    end

    def initialize
      @include_root_in_json = false
      @i18n_scope = :active_data
      @logger = Logger.new(STDERR)
      @primary_attribute = :id
      @_normalizers = {}
      @_typecasters = {}
      @persistence_adapters = PersistenceAdapters.new
    end

    def normalizer name, &block
      if block
        _normalizers[name.to_sym] = block
      else
        _normalizers[name.to_sym] or raise NormalizerMissing.new(name)
      end
    end

    def typecaster *classes, &block
      classes = classes.flatten
      if block
        _typecasters[classes.first.to_s.camelize] = block
      else
        _typecasters[classes.detect do |klass|
          _typecasters[klass.to_s.camelize]
        end.to_s.camelize] or raise TypecasterMissing.new(*classes)
      end
    end
  end
end
