require 'thor'
require 'togostanza'

module TogoStanza
  module CLI
    class Root < Thor
      desc 'server', 'Launch app server'
      def server
        TogoStanza::Application.run!
      end
    end
  end
end
