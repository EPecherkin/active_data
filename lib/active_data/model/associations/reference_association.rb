module ActiveData
  module Model
    module Associations
      class ReferenceAssociation < Base
        def scope(source = read_source)
          reflection.persistence_adapter.scope(source)
        end
      end
    end
  end
end
