module ActiveData
  module Model
    module Associations
      class ReferencesMany < ReferenceAssociation
        def apply_changes
          present_keys = target.reject { |t| t.marked_for_destruction? }.map(&reflection.primary_key).compact
          write_source(present_keys)
          true
        end

        def target= object
          loaded!
          @target = object.to_a
        end

        def load_target
          source = read_source
          source.present? ? reflection.persistence_adapter.find_all(source) : default
        end

        def default
          unless evar_loaded?
            default = Array.wrap(reflection.default(owner))
            if default.all? { |object| object.is_a?(reflection.klass) }
              default
            elsif default.all? { |object| object.is_a?(Hash) }
              default.map { |attributes| reflection.klass.new(attributes) }
            else
              reflection.persistence_adapter.find_all(default)
            end if default.present?
          end || []
        end

        def read_source
          attribute.read_before_type_cast
        end

        def write_source value
          attribute.write_value value
        end

        def reader force_reload = false
          reload if force_reload
          @proxy ||= Collection::Referenced.new self
        end

        def replace objects
          loaded!
          transaction do
            clear
            append objects
          end
        end
        alias_method :writer, :replace

        def concat(*objects)
          append objects.flatten
          reader
        end

        def clear
          attribute.pollute do
            write_source([])
          end
          reload.empty?
        end

        def identify
          target.map(&reflection.primary_key)
        end

      private

        def append objects
          attribute.pollute do
            objects.each do |object|
              next if target.include?(object)
              raise AssociationTypeMismatch.new(reflection.klass, object.class) unless object.is_a?(reflection.klass)
              target.push(object)
              apply_changes!
            end
          end
          target
        end

        def attribute
          @attribute ||= owner.attribute(reflection.reference_key)
        end
      end
    end
  end
end
