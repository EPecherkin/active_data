module ActiveData
  module Model
    module Associations
      module Reflections
        class ReferenceReflection < Base
          def self.build target, generated_methods, name, *args, &block
            reflection = new(name, *args)
            generate_methods name, generated_methods
            reflection
          end

          def initialize name, *args
            @options = args.extract_options!
            @scope_proc = args.first
            @name = name.to_sym
          end

          def read_source object
            object.read_attribute(reference_key)
          end

          def write_source object, value
            object.write_attribute(reference_key, value)
          end

          def primary_key
            @primary_key ||= options[:primary_key].presence.try(:to_sym) || :id
          end

          def scope
            @scope ||= begin
              scope = klass.unscoped
              scope = scope.instance_exec(&@scope_proc) if @scope_proc
              scope
            end
          end

          def embedded?
            false
          end

          def persistence_adapter
            @persistence_adapter ||= options[:persistence_adapter] || ActiveData.persistence_adapter
          end
        end
      end
    end
  end
end
