module ActiveData::Model::Associations::PersistenceAdapters
  class Base
    attr_reader :klass, :primary_key, :scope_proc

    def initialize(klass, primary_key = :id, scope_proc = nil)
      @klass = klass
      @primary_key = primary_key
      @scope_proc = scope_proc
    end

    def find(identificator)
      scope(identificator).first
    end

    def find_all(identificators)
      scope(identificators).to_a
    end

    def scope(source)
      raise NotImplementedError, 'Should be implemented in inhereted adapter. Better to be Enumerable'
    end

    def primary_key_type
      raise NotImplementedError, 'Should be implemented in inhereted adapter. Should be ruby data type'
    end
  end
end
