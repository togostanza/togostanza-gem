require 'thor'
require 'active_support/all'

module TogoStanza
  module CLI
    class ProviderGenerator < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.expand_path('../../../templates/provider', __FILE__)
      end

      def create_files
        template 'gitignore.erb',         "#{name}/.gitignore"
        template 'Gemfile.erb',           "#{name}/Gemfile"
        template 'config.ru.erb',         "#{name}/config.ru"
        template 'Procfile.erb',          "#{name}/Procfile"
        template 'config/unicorn.rb.erb', "#{name}/config/unicorn.rb"

        create_file "#{name}/log/.keep"
      end

      def init_repo
        inside name do
          run "bundle"
          run "git init ."
          run "git add -A"
        end
      end
    end

    class StanzaGenerator < Thor::Group
      include Thor::Actions

      argument :name

      def self.source_root
        File.expand_path('../../../templates/stanza', __FILE__)
      end

      def create_files
        template 'Gemfile.erb',      "#{file_name}/Gemfile"
        template 'gemspec.erb',      "#{file_name}/#{file_name}.gemspec"
        template 'lib.rb.erb',       "#{file_name}/lib/#{file_name}.rb"
        template 'stanza.rb.erb',    "#{file_name}/stanza.rb"
        template 'template.hbs.erb', "#{file_name}/template.hbs"
        template 'help.md.erb',      "#{file_name}/help.md"

        create_file "#{file_name}/assets/.keep"
      end

      def inject_gem
        append_to_file 'Gemfile', "gem '#{file_name}', path: './#{file_name}'\n"
      end

      private

      def stanza_id
        name.underscore.sub(/_stanza$/, '')
      end

      def file_name
        stanza_id + '_stanza'
      end

      def class_name
        file_name.classify
      end

      def title
        stanza_id.titleize
      end
    end

    class Stanza < Thor
      register StanzaGenerator, 'new', 'new NAME', 'Creates a new stanza'
    end

    class Root < Thor
      register ProviderGenerator, 'init', 'init NAME', 'Creates a new provider'

      desc 'stanza [COMMAND]', ''
      subcommand 'stanza', Stanza
    end
  end
end
