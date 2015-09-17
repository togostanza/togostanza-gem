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
        template 'Gemfile.erb',       "#{file_name}/Gemfile"
        template 'gemspec.erb',       "#{file_name}/#{file_name}.gemspec"
        template 'lib.rb.erb',        "#{file_name}/lib/#{file_name}.rb"
        template 'stanza.rb.erb',     "#{file_name}/stanza.rb"
        template 'template.hbs.erb',  "#{file_name}/template.hbs"
        template 'help.md.erb',       "#{file_name}/help.md"
        template 'metadata.json.erb', "#{file_name}/metadata.json"

        create_file "#{file_name}/assets/#{stanza_id}/.keep"
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

    class NameModifier < Thor::Group
      include Thor::Actions

      argument :name1
      argument :name2

      def replace_description
        gsub_file("#{file_name(name1)}/help.md", title(name1), title(name2))
        gsub_file("#{file_name(name1)}/help.md", stanza_id(name1), stanza_id(name2))
        gsub_file("#{file_name(name1)}/#{file_name(name1)}.gemspec", file_name(name1), file_name(name2))
        gsub_file("#{file_name(name1)}/lib/#{file_name(name1)}.rb", class_name(name1), class_name(name2))
        gsub_file("#{file_name(name1)}/metadata.json", stanza_id(name1), stanza_id(name2))
        gsub_file("#{file_name(name1)}/stanza.rb", class_name(name1), class_name(name2))
        gsub_file("#{file_name(name1)}/template.hbs", title(name1), title(name2))
        gsub_file("#{file_name(name1)}/template.hbs", "assets/#{stanza_id(name1)}","assets/#{stanza_id(name2)}")
        gsub_file("#{file_name(name1)}/template.hbs", "#{stanza_id(name1)}/resources", "#{stanza_id(name2)}/resources")
        gsub_file("Gemfile", "#{file_name(name1)}", "#{file_name(name2)}")
      end

      def rename_directory
        File.rename("#{file_name(name1)}/assets/#{stanza_id(name1)}", "#{file_name(name1)}/assets/#{stanza_id(name2)}")
        File.rename("#{file_name(name1)}/lib/#{file_name(name1)}.rb", "#{file_name(name1)}/lib/#{file_name(name2)}.rb")
        File.rename("#{file_name(name1)}/#{file_name(name1)}.gemspec", "#{file_name(name1)}/#{file_name(name2)}.gemspec")
        File.rename("#{file_name(name1)}", "#{file_name(name2)}")
      end

      private

      def stanza_id(name)
        name.underscore.sub(/_stanza$/, '')
      end

      def file_name(name)
        stanza_id(name)  + '_stanza'
      end

      def class_name(name)
        file_name(name).classify
      end

      def title(name)
        stanza_id(name).titleize
      end
    end

    class NameRegister < Thor::Group
      include Thor::Actions

      argument :name

      def template_dir
        File.expand_path('../../../templates/stanza', __FILE__)
      end

      def replace_author
          gsub_file("#{template_dir}/gemspec.erb", /spec.authors\s*=\s\[\'.*\'\]/, "spec.authors       = ['#{name}']")
          gsub_file("#{template_dir}/metadata.json.erb", /author":\s".*"/, "author\": \"#{name}\"")
      end
    end

    class MailRegister < Thor::Group
      include Thor::Actions

      argument :name

      def template_dir
        File.expand_path('../../../templates/stanza', __FILE__)
      end

      def replace_author
          gsub_file("#{self.source_root}/gemspec.erb", /spec.email\s*=\s\[\'.*\'\]/, "spec.email         = ['#{name}']")
          gsub_file("#{self.source_root}/metadata.json.erb", /address":\s".*"/, "address\": \"#{name}\"")
      end
    end

    class Stanza < Thor
      register StanzaGenerator, 'new', 'new NAME', 'Creates a new stanza'
    end

    class Stanza < Thor
      register NameModifier, 'modify', 'modify NAME1 NAME2', 'Modify a name of stnza'
    end

    class Root <Thor
        register NameRegister, 'name' , 'name NAME' , 'register your name'
    end

    class Root <Thor
        register MailRegister, 'mail' , 'mail NAME' , 'register your mail'
    end

    class Root < Thor
      register ProviderGenerator, 'init', 'init NAME', 'Creates a new provider'

      desc 'stanza [COMMAND]', ''
      subcommand 'stanza', Stanza
    end
  end
end
