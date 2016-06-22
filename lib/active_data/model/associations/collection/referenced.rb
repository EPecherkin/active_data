module ActiveData
  module Model
    module Associations
      module Collection
        class Referenced < Proxy
          delegate :scope, to: :@association

          def method_missing(method, *args, &block)
            delegate_to_scope?(method) ? scope.send(method, *args, &block) : super
          end

          def respond_to_missing?(method, include_private = false)
            delegate_to_scope?(method) || super
          end

        private

          def delegate_to_scope?(method)
            @association.reflection.persistence_adapter.class::METHODS_EXCLUDED_FROM_DELEGATION
              .exclude?(method) && scope.respond_to?(method)
          end
        end
      end
    end
  end
end
