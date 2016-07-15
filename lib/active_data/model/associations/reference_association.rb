module ActiveData
  module Model
    module Associations
      class ReferenceAssociation < Base
        def scope(source = read_source)
          persistence_adapter.scope(source)
        end

        def persistence_adapter
          @persistence_adapter ||= ActiveData.persistence_adapter(reflection.klass).call(reflection.klass, reflection.primary_key, reflection.scope_proc)
        end
      end
    end
  end
end
