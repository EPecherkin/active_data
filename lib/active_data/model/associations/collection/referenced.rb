module ActiveData
  module Model
    module Associations
      module Collection
        class Referenced < Proxy
          delegate :scope, to: :@association

          def method_missing(method, *args, &block)
            scope.respond_to?(method) ? scope.send(method, *args, &block) : super
          end

          def respond_to_missing?(method, include_private = false)
            scope.respond_to?(method) || super
          end
        end
      end
    end
  end
end
