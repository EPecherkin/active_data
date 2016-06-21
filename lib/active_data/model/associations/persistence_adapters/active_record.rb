module ActiveData::Model::Associations::PersistenceAdapters
  class ActiveRecord
    def initialize(klass, primary_key = :id, scope_proc = nil)
      @scope = klass
      @klass = klass.unscoped
      @primary_key = primary_key
      @scope_proc = scope_proc

      @scope = @scope.unscoped.instance_exec(&@scope_proc) if scope_proc
    end

    def find(identificator)
      @scope.where(@primary_key => identificator).first
    end

    def find_all(identificators)
      @scope.where(@primary_key => identificators).to_a
    end
  end
end
