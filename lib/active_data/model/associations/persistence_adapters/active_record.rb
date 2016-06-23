module ActiveData::Model::Associations::PersistenceAdapters
  class ActiveRecord < Base
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
