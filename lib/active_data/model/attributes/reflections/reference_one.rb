module ActiveData
  module Model
    module Attributes
      module Reflections
        class ReferenceOne < Base
          def self.build target, generated_methods, name, *args, &block
            options = args.extract_options!
            generate_methods name, generated_methods
            type_proc = -> {
              reflection = target.reflect_on_association(options[:association])
              reflection.persistence_adapter.primary_key_type
            }
            new(name, options.reverse_merge(type: type_proc))
          end

          def self.generate_methods name, target
            target.class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{name}
                attribute('#{name}').read
              end

              def #{name}= value
                attribute('#{name}').write(value)
              end

              def #{name}?
                attribute('#{name}').query
              end

              def #{name}_before_type_cast
                attribute('#{name}').read_before_type_cast
              end
            RUBY
          end

          def association
            @association ||= options[:association].to_s
          end
        end
      end
    end
  end
end
