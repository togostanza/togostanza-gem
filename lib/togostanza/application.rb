require 'sinatra/base'
require 'sinatra/reloader'

module TogoStanza
  class Application < Sinatra::Base
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
  end
end
