require 'thor'
require 'togostanza'

module TogoStanza
  module CLI
    class NewStanza < Thor::Group
      include Thor::Actions

      argument :name

      def foo
        puts name
      end
    end

    class Stanza < Thor
      register NewStanza, 'new', 'new NAME', 'Generate a new stanza'
    end

    class Root < Thor
      desc 'init [NAME]', 'Initialize stanza provider'
      def init
      end

      desc 'server', 'Launch app server'
      def server
        TogoStanza::Application.run!
      end

      desc 'stanza [COMMAND]', ''
      subcommand 'stanza', Stanza
    end
  end
end
