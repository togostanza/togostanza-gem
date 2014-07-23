require 'active_support/core_ext/class/attribute'

module TogoStanza::Stanza
  module TextSearch
    def text_search(q)
      search_declarations.each_value.flat_map {|block| instance_exec(q, &block) }
    end

    module ClassMethods
      def search(symbol, &block)
        search_declarations[symbol] = block
      end
    end

    def self.included(klass)
      klass.extend ClassMethods

      klass.instance_eval do
        # テキスト検索宣言の初期化
        class_attribute :search_declarations
        self.search_declarations = {}
      end
    end
  end
end
