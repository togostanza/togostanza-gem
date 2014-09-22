require 'active_support/core_ext/class/attribute'

class TogoStanza::NoSearchDeclarationError < StandardError; end

module TogoStanza::Stanza
  module TextSearch

    def text_search(q)
      raise TogoStanza::NoSearchDeclarationError unless self.class.method_defined?(:search_declarations)

      return [] if q.blank?

      search_declarations.each_value.flat_map {|block| instance_exec(q, &block) }
    end

    module ClassMethods
      def search(symbol, &block)
        unless method_defined?(:search_declarations)
          # テキスト検索宣言の初期化
          instance_eval do
            class_attribute :search_declarations
            self.search_declarations = {}
          end
        end

        search_declarations[symbol] = block
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end
