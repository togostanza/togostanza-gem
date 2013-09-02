require 'active_support/all'

module TogoStanza::Stanza
  autoload :Base, 'togostanza/stanza/base'

  class << self
    def find(id)
      "#{id.camelize}Stanza".constantize
    end

    def all
      Base.descendants
    end

    def root
      Pathname(ENV['STANZA_ROOT'] || './stanza').expand_path
    end

    def load_all!
      Dir[root.join('*_stanza.rb')].each do |f|
        require f
      end
    end
  end
end
