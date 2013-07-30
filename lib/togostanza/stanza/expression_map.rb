require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'active_support/hash_with_indifferent_access'
require 'parallel'

module TogoStanza::Stanza
  class ExpressionMap < HashWithIndifferentAccess
    module Macro
      def define_expression_map(name)
        class_attribute name

        __send__ "#{name}=", ExpressionMap.new

        define_singleton_method name.to_s.singularize do |key, val = nil, &block|
          raise ArgumentError, 'You must specify exactly one of either a value or block' unless [val, block].one?(&:nil?)

          __send__ "#{name}=", __send__(name).merge(key => block || val)
        end
      end
    end

    def resolve(context, key, params)
      val = self[key]

      return val unless val.respond_to?(:call)

      args = val.parameters.reject {|type, _|
        type == :block
      }.map {|_, key|
        params[key]
      }

      context.instance_exec(*args, &val)
    end

    def resolve_all_in_parallel(context, params)
      Parallel.map(self, in_threads: 16) {|k, v|
        [k, resolve(context, k, params)]
      }.each_with_object({}) {|(k, v), memo|
        memo[k] = v
      }
    end
  end
end
