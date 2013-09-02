require 'sinatra/base'
require 'sinatra/reloader'
require 'haml'

module TogoStanza
  class Application < Sinatra::Base
    set :root, File.expand_path('../..', __dir__)
    set :haml, escape_html: true

    configure :development do
      register Sinatra::Reloader
    end

    helpers do
      def path(*paths)
        prefix = env['SCRIPT_NAME']

        [prefix, *paths].join('/').squeeze('/')
      end
    end

    get '/' do
      haml :index
    end

    get '/:id' do |id|
      Stanza.find(id).new(params).render
    end

    get '/:id/resources/:resource_id' do |id, resource_id|
      Stanza.find(id).new(params).resource(resource_id)
    end

    get '/:id/help' do |id|
      Stanza.find(id).new.help
    end
  end
end
