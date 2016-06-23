module ActiveData::Model::Associations::PersistenceAdapters
  class ActiveRecord

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
      @scope ||= (scope_proc ? klass.unscoped.instance_exec(&scope_proc) : klass.unscoped)
      @scope.where(primary_key => source)
    end

    # Used in lib/active_data/model/associations/collection/referenced.rb
    # You can't create data directly through scope
    def methods_excluded_from_delegation_to_scope
      @methods_excluded_from_delegation_to_scope ||= %w[build create create!].map(&:to_sym).freeze
    end
  end
end
