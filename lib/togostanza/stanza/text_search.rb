require 'togostanza/stanza/search_query'

class TogoStanza::NoSearchDeclarationError < StandardError; end

module TogoStanza::Stanza
  module TextSearch
    extend ActiveSupport::Concern

    def text_search_filter(var_name, query)
      query.to_filter(TogoStanza.text_search_method, var_name)
    end

    def text_search(input)
      raise TogoStanza::NoSearchDeclarationError unless self.class.method_defined?(:search_declarations)

      query = SearchQuery.new(input)

      return [] if query.tokens.empty?

      search_declarations.each_value.flat_map {|block|
        instance_exec(query, &block)
      }
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
  end
end
