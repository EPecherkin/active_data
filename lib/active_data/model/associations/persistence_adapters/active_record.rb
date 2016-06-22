module ActiveData::Model::Associations::PersistenceAdapters
  class ActiveRecord
    METHODS_EXCLUDED_FROM_DELEGATION = %w[build create create!].map(&:to_sym).freeze

    def initialize(klass, primary_key = :id, scope_proc = nil)
      @klass = klass.unscoped
      @primary_key = primary_key
      @scope_proc = scope_proc

      @scope = klass
      @scope = @klass.instance_exec(&@scope_proc) if scope_proc
    end

    def find(identificator)
      scope(identificator).first
    end

    def find_all(identificators)
      scope(identificators).to_a
    end

    def scope(source)
      @scope.where(@primary_key => source)
    end
  end
end
