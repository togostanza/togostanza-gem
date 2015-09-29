require 'togostanza/version'
require 'sprockets'

module TogoStanza
  autoload :Application, 'togostanza/application'
  autoload :CLI,         'togostanza/cli'
  autoload :Markdown,    'togostanza/markdown'
  autoload :Stanza,      'togostanza/stanza'

  class << self
    def sprockets
      @sprockets ||= Sprockets::Environment.new.tap {|sprockets|
        sprockets.append_path File.expand_path('../../assets', __FILE__)
      }
    end
  end
end
