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
  end
end
