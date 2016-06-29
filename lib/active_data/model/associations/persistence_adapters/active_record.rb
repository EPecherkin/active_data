module ActiveData
  module Model
    module Associations
      module PersistenceAdapters
        class ActiveRecord < Base
          class ScopeProxy
            # You can't create data directly through ActiveRecord::Relation
            METHODS_EXCLUDED_FROM_DELEGATION = %w[build create create!].map(&:to_sym).freeze

            attr_reader :original_scope

            def initialize(original_scope)
              @original_scope = original_scope
            end

            def method_missing(method, *args, &block)
              delegate_to_original_scope?(method) ? original_scope.send(method, *args, &block) : super
            end

            def respond_to_missing?(method, include_private = false)
              delegate_to_original_scope?(method) || super
            end

            def delegate_to_original_scope?(method)
              METHODS_EXCLUDED_FROM_DELEGATION.exclude?(method) && original_scope.respond_to?(method)
            end
          end

          def find_one(identificator)
            raw_scope(identificator).first
          end

          def find_all(identificators)
            raw_scope(identificators).to_a
          end

          def scope(source)
            ScopeProxy.new(raw_scope(source))
          end

          def raw_scope(source)
            raw_scope = (scope_proc ? klass.unscoped.instance_exec(&scope_proc) : klass.unscoped)
            raw_scope.where(primary_key => source)
          end

          TYPES = {
            integer: Integer,
            float: Float,
            decimal: BigDecimal,
            datetime: Time,
            timestamp: Time,
            time: Time,
            date: Date,
            text: String,
            string: String,
            binary: String,
            boolean: Boolean
          }

          def primary_key_type
            column = klass.columns_hash[primary_key.to_s]
            TYPES[column.type]
          end
        end
      end
    end
  end
end
